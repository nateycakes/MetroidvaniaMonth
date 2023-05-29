extends Node

signal player_died
signal checkpoint_reached(checkpoint_position)

var playerSpawnLocation: Vector2 = Vector2.ZERO
var current_save_room : String = ""
