extends Node

signal player_died
signal save_point_reached(save_point_position) # used by Room.tscn to determine if player walked into save point

var playerSpawnLocation: Vector2 = Vector2.ZERO #x,y coords for where we plop down a player
var current_save_room : String = "" #path to the currently set save room

var current_room_path : String = "" #path to the resource of the current room
var previous_room_path : String = "" #path to the resource of the previous room

var player_collected_claws : bool = true #variable to track if the player collected melee indepentent of scenes
