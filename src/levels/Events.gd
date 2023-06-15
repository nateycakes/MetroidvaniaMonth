extends Node

signal player_died
signal save_point_reached(room_position, room_path) # used by Room.tscn to determine if player walked into save point
signal jump_ability_collected
signal melee_ability_collected


#enum for all diff regions a room could be. Doing this here bc it's basically our game manager
enum biomes { 
	ARCHIVES,
	CHECKPOINT,
	HIGHRISE,
	STREETS,
	UNDERGROUND
}

var lorebook_entries : Array = []


const START_ROOM_PATH = "res://src/levels/build/StartRoom.tscn"

var current_room_biome = null
var previous_room_biome = biomes.STREETS #I need SOME default value

var gameStart : bool = true #flag for when the game initially starts
var gamePaused : bool = false


var playerSpawnLocation: Vector2 = Vector2.ZERO #x,y coords for where we plop down a player
var current_save_room : String = "" #path to the currently set save room
var save_point_position : Vector2 = Vector2.ZERO #x,y coords for the save point we last interacted with
var player_just_died : bool = false #used for logic in Room.gd for determining where to plop player down

var current_room_path : String = "" #path to the resource of the current room
var previous_room_path : String = "" #path to the resource of the previous room

var has_collected_claws : bool = false  #variable to track if the player collected melee indepentent of scenes
var has_collected_double_jump : bool = false #global lock for the double jump

func add_lorebook_entry(lorebookID):
	lorebook_entries.push_front(lorebookID)
