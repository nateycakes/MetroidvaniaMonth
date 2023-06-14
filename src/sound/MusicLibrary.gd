extends Resource
class_name MusicLibrary

# Catalogue of all songs in the game. Initilize as consts so we have autocomplete access to them
#
# ADDING SONGS: to add a song, copy the below text and replace as follows:
#
#  SONG_NAME  : the variable we call to refer to this particular song
#  preload()   : drag the resource from the file browser in the editor to automatically format the 
#                filepath for Godot to understand
#                PLACE THE VALUE IN QUOTES IN THE preload() PARENTHESIS
#
#const SONG_NAME: Resource = preload()

const ARCHIVES: Resource = preload("res://assets/soundAssets/bgm/bgm_archives.ogg")
const CHECKPOINT : Resource = preload("res://assets/soundAssets/bgm/bgm_checkpoint.ogg")
const HIGHRISE: Resource = preload("res://assets/soundAssets/bgm/bgm_highrise.ogg")
const STREETS: Resource = preload("res://assets/soundAssets/bgm/bgm_streets.ogg")
const UNDERGROUND: Resource = preload("res://assets/soundAssets/bgm/bgm_underground.ogg")
const TITLE_SCREEN: Resource = preload("res://assets/soundAssets/bgm/bgm_title.ogg")
const VICTORY_SCREEN: Resource = preload("res://assets/soundAssets/bgm/bgm_victory.ogg")

