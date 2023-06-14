extends Resource
class_name SoundLibrary

# Catalogue of all sounds in the game. Initilize as consts so we have autocomplete access to them
#
# ADDING SOUNDS: to add a sound, copy the below text and replace as follows:
#
#  SOUND_NAME  : the variable we call to refer to this particular sound
#  preload()   : drag the resource from the file browser in the editor to automatically format the 
#                filepath for Godot to understand
#                PLACE THE VALUE IN QUOTES IN THE preload() PARENTHESIS
#
#const SOUND_NAME: Resource = preload()

#######   PLAYER SOUNDS  #######
const CAT_ATTACK : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_attack.wav")
const CAT_DOUBLEJUMP : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_doublejump.wav")
const CAT_HURT : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_hurt.wav")
const CAT_JUMP : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_jump.wav")
const CAT_LAND : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_land.wav")
const CAT_MEOW : Resource = preload("res://assets/soundAssets/sfx/sfx_cat_meow.wav")
const CAT_DEATH: Resource = preload("res://assets/soundAssets/sfx/sfx_cat_death.wav")

######  ENEMY SOUNDS  ##########
const DRONE_DEACTIVATE : Resource = preload("res://assets/soundAssets/sfx/sfx_drone_deactivate.wav")


######  HAZARD SOUNDS  ##########
const FLOOR_DAMAGE : Resource = preload("res://assets/soundAssets/sfx/sfx_floor_damage.wav")


###### CHECKPOINT SOUNDS #######
const CHECKPOINT_ACTIVATE : Resource = preload("res://assets/soundAssets/sfx/sfx_checkpoint_activate.wav")
const CHECKPOINT_RELOAD : Resource = preload("res://assets/soundAssets/sfx/sfx_checkpoint_reload.wav")
const CHECKPOINT_FINAL : Resource = preload("res://assets/soundAssets/sfx/sfx_final_activate.wav")


######  DOOR SOUNDS  ###########
const DOOR_OPEN_LARGE: Resource = preload("res://assets/soundAssets/sfx/sfx_door_open.wav")
const DOOR_OPEN_SMALL: Resource = preload("res://assets/soundAssets/sfx/sfx_tile_destruct.wav")


#####  COLLECTIBLE SOUNDS  #######
const PICKUP_DISC : Resource = preload("res://assets/soundAssets/sfx/sfx_pickup_disc.wav")
const PICKUP_HEALTH : Resource = preload("res://assets/soundAssets/sfx/sfx_pickup_health.wav")
const PICKUP_POWERUP : Resource = preload("res://assets/soundAssets/sfx/sfx_pickup_powerup.wav")





