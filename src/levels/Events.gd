extends Node

signal player_died
signal save_point_reached(save_point_position) # used by Room.tscn to determine if player walked into save point

var playerSpawnLocation: Vector2 = Vector2.ZERO
var current_save_room : String = ""

var current_room_path : String = ""
var previous_room_path : String = ""
