extends Node2D

const PlayerScene = preload("res://src/actors/Player.tscn")
const death_length = 1 #how long should we chill when the player dies?

onready var camera: Camera2D = $Camera2D
onready var player: KinematicBody2D = $Player
onready var respawnTimer: Timer = $RespawnTimer

#where should we place the player when the room starts?
var player_spawn_location = Vector2.ZERO
#var for holding the path of the last room the player left. Used for player spawn location logic
var from_room: String = "" 

func _ready() -> void:
	player.connect_camera(camera)
	#player_spawn_location = player.position
	room_setup()
	Events.connect("player_died", self, "_on_player_died") #listen for global player_died signal from Events.gd
	Events.connect("save_point_reached", self, "_on_save_point_reached")

func room_setup():
	determine_enter_location()
	player.position = player_spawn_location
	#we are now finished setting up the current room which will be the next "previous room" when we transition
	Events.previous_room_path = filename


func determine_enter_location():
	#iterate through all the room's potential spawn zones, and match the zones' "from_room" to the one set in Events.gd
	var entryPoints = get_tree().get_nodes_in_group("Spawn_Zones")
	#if there are no entry points, dont do this (might help for inital game state)
	if entryPoints.empty(): return #or Events.previous_room_path = ""
	
	for spawnPoint in get_tree().get_nodes_in_group("Spawn_Zones") :
		#find the spawnPoint that has our previous room
		if spawnPoint.from_room_scene == Events.previous_room_path:
			# if player.debug: print("found correct spawnpoint at location : " + str(spawnPoint.position.x) + " , " + str(spawnPoint.position.y))
			#we have our correct spawnpoint, play the corresponding screen transition
			ScreenTransitions.play_transition(spawnPoint.transition_type)
			update_player_spawn_location(spawnPoint.position)

func update_player_spawn_location(newSpawnLocation : Vector2):
	player_spawn_location = newSpawnLocation

func _on_player_died():
	#func to run when the player dies idk what to tell you
	respawnTimer.start(death_length)
	yield(respawnTimer, "timeout") #wait for the timer to finish
	instance_new_player(player_spawn_location)

func instance_new_player(location):
	#handle creating a new player instance and setting its position within the scene
	var player = PlayerScene.instance()
	player.position = location
	add_child(player)
	player.connect_camera(camera)

func _on_save_point_reached(newSpawnLocation):
	update_player_spawn_location(newSpawnLocation)
