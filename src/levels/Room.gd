extends Node2D

const PlayerScene = preload("res://src/actors/Player.tscn")
const death_length = 1 #how long should we chill when the player dies?

onready var camera: Camera2D = $Camera2D
onready var player: KinematicBody2D = $Player
onready var respawnTimer: Timer = $RespawnTimer

var player_spawn_location = Vector2.ZERO
#var for holding the path of the last room the player left. Used for player spawn location logic
var from_room: String = "" 

func _ready() -> void:
	player.connect_camera(camera)
	player_spawn_location = player.position
	Events.connect("player_died", self, "_on_player_died") #listen for global player_died signal from Events.gd
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")

func update_player_spawn_location(newSpawnLocation):
	player_spawn_location = newSpawnLocation

func _on_player_died():
	respawnTimer.start(death_length)
	yield(respawnTimer, "timeout") #wait for the timer to finish
	instance_new_player(player_spawn_location)

func instance_new_player(location):
	#handle creating a new player instance and setting its position within the scene
	var player = PlayerScene.instance()
	player.position = location
	add_child(player)
	player.connect_camera(camera)

func _on_checkpoint_reached(newSpawnLocation):
	update_player_spawn_location(newSpawnLocation)
