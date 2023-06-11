extends Resource
class_name RoomBackgroundLibrary

# Catalogue of all Room Backgrounds in the game. Initilize as consts so we have autocomplete access to them
#
# ADDING BACKGROUNDS: to add a background, copy the below text and replace as follows:
#
#  BACKGROUND_LAYER_NAME  : the variable we call to refer to this particular background layer
#  preload()   : drag the resource from the file browser in the editor to automatically format the 
#                filepath for Godot to understand
#                PLACE THE VALUE IN QUOTES IN THE preload() PARENTHESIS
#
#const BACKGROUND_LAYER_NAME: Resource = preload()

const ARCHIVES_LAYER_BACK: Resource = preload("res://assets/levelAssets/backgrounds/archives_p_layer_back.png")
const ARCHIVES_LAYER_FRONT: Resource = preload("res://assets/levelAssets/backgrounds/archives_p_layer_front.png")
const CHECKPOINT_LAYER_BACK: Resource = preload("res://assets/levelAssets/backgrounds/checkpoint_p_layer_back.png")
const CHECKPOINT_LAYER_FRONT: Resource = preload("res://assets/levelAssets/backgrounds/checkpoint_p_layer_front.png")
const HIGHRISE_LAYER_BACK: Resource = preload("res://assets/levelAssets/backgrounds/highrise_p_layer_back.png")
const HIGHRISE_LAYER_FRONT: Resource = preload("res://assets/levelAssets/backgrounds/highrise_p_layer_front.png")
const STREETS_LAYER_BACK: Resource = preload("res://assets/levelAssets/backgrounds/streets_p_layer_back.png")
const STREETS_LAYER_FRONT: Resource = preload("res://assets/levelAssets/backgrounds/streets_p_layer_front.png")
const UNDERGROUND_LAYER_BACK: Resource = preload("res://assets/levelAssets/backgrounds/underground_p_layer_back.png")
const UNDERGROUND_LAYER_FRONT: Resource = preload("res://assets/levelAssets/backgrounds/underground_p_layer_front.png")


