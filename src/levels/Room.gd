extends Node2D

const PlayerScene = preload("res://src/actors/Player.tscn")
const death_length = 1 #how long should we chill when the player dies?

onready var roomBackgroundLibrary: RoomBackgroundLibrary = preload("res://src/levels/RoomBackgroundLibrary.tres") as RoomBackgroundLibrary

onready var camera: Camera2D = $Camera2D
onready var player: KinematicBody2D = $Player
onready var respawnTimer: Timer = $RespawnTimer
onready var roomBackground = $RoomBackground

export(Events.biomes) var biome 

#where should we place the player when the room starts?
var player_spawn_location = Vector2.ZERO
#var for holding the path of the last room the player left. Used for player spawn location logic
var from_room: String = "" 


func _ready() -> void:
	player.connect_camera(camera)
	room_setup()
	Events.connect("player_died", self, "_on_player_died") #listen for global player_died signal from Events.gd
	Events.connect("save_point_reached", self, "_on_save_point_reached")

func room_setup():
	determine_enter_location()
	Events.current_room_biome = biome #set the biome in the events appropriately
	
	if Events.previous_room_biome != biome:
		#print("entering a new biome")
		var newBGM = match_bgm_to_biome(biome)
		MusicPlayer.crossfade_songs(newBGM)
		set_room_background(biome)
		
	player.position = player_spawn_location
	#we are now finished setting up the current room which will be the next "previous room" when we transition
	Events.previous_room_path = filename
	Events.previous_room_biome = biome

func match_background_to_biome(biomeType):
	#this function matches the enumerator defined in Events.gd to their corresponding resource as defined
	#in the roomBackgroundLibrary and returns an array of [BACK LAYER, FRONT LAYER] as defined in the roomBackgroundLibrary
	match biomeType:
		Events.biomes.ARCHIVES:
			return [ roomBackgroundLibrary.ARCHIVES_LAYER_BACK, roomBackgroundLibrary.ARCHIVES_LAYER_FRONT ]
		Events.biomes.CHECKPOINT:
			return [ roomBackgroundLibrary.CHECKPOINT_LAYER_BACK, roomBackgroundLibrary.CHECKPOINT_LAYER_FRONT ]
		Events.biomes.HIGHRISE:
			return [ roomBackgroundLibrary.HIGHRISE_LAYER_BACK, roomBackgroundLibrary.HIGHRISE_LAYER_FRONT ]
		Events.biomes.STREETS:
			return [ roomBackgroundLibrary.STREETS_LAYER_BACK, roomBackgroundLibrary.STREETS_LAYER_FRONT ]
		Events.biomes.UNDERGROUND:
			return [ roomBackgroundLibrary.UNDERGROUND_LAYER_BACK, roomBackgroundLibrary.UNDERGROUND_LAYER_FRONT ]
	#default value in case something isn't set correctly
	#return MusicPlayer.library.STREETS

func set_room_background(biomeType):
	var biomeBG = [ "", "" ]
	biomeBG  = match_background_to_biome(biomeType)
	roomBackground.set_background(biomeBG[0], biomeBG[1])
	

func match_bgm_to_biome(biomeType):
	#this function matches the enumerator defined in Events.gd to their corresponding resource as defined
	#in the musicLibrary and returns the matching resource from musicLibrary
	match biomeType:
		Events.biomes.ARCHIVES:
			return MusicPlayer.library.ARCHIVES
		Events.biomes.CHECKPOINT:
			return MusicPlayer.library.CHECKPOINT
		Events.biomes.HIGHRISE:
			return MusicPlayer.library.HIGHRISE
		Events.biomes.STREETS:
			return MusicPlayer.library.STREETS
		Events.biomes.UNDERGROUND:
			return MusicPlayer.library.UNDERGROUND
	#default value in case something isn't set correctly
	#return MusicPlayer.library.STREETS


func determine_enter_location():
	#iterate through all the room's potential spawn zones, and match the zones' "from_room" to the one set in Events.gd
	var entryPoints = get_tree().get_nodes_in_group("Spawn_Zones")
	#if there are no entry points, dont do this (might help for inital game state)
	if entryPoints.empty(): return #Events.previous_room_path = ""
	
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
	Events.player_just_died = true
	yield(respawnTimer, "timeout") #wait for the Respawntimer to finish
	instance_new_player(player_spawn_location)

func instance_new_player(location):
	#handle creating a new player instance and setting its position within the scene
	var newPlayer = PlayerScene.instance()
	newPlayer.position = location
	add_child(newPlayer)
	newPlayer.connect_camera(camera) #use player's connect cam function to connect here
	PlayerStats.health = PlayerStats.max_health #set the GLOBAL PlayerStats health to full

func _on_save_point_reached(newSavePointPosition, newSavePointFilepath):
	#FIRED WHEN THE PLAYER COLLIDES WITH A SAVE POINT
	update_player_spawn_location(newSavePointPosition)
	Events.current_save_room = newSavePointFilepath
	Events.save_point_position = newSavePointPosition
	
