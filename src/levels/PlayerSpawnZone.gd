extends Area2D
class_name PlayerSpawnZone
# Node responsible for handling the transition of entering a new room and correctly determining the 
# door the player should be placed in front of based upon the room set within the from_room_path var
# 
#
enum SPAWN_ZONE_TYPES { 
	ROOM_ENTRY_POINT, 
	SAVE_POINT
	}

export(SPAWN_ZONE_TYPES) var spawn_zone_type = SPAWN_ZONE_TYPES.ROOM_ENTRY_POINT
#from_room_scene is the room the scene the player would be entering from in order to spawn here
export(String, FILE, "*.tscn") var from_room_scene = ""

export(String, 
	"ENTER_LEFT",
	"ENTER_RIGHT",
	"ENTER_UP",
	"ENTER_DOWN",
	"EXIT_LEFT",
	"EXIT_RIGHT",
	"EXIT_UP",
	"EXIT_DOWN",
	"DEFAULT_IN",
	"DEFAULT_OUT",
	"NONE"
) var transition_type = "NONE"

onready var checkpointSprite : AnimatedSprite = $checkpointSprite

func _ready() -> void:
	if spawn_zone_type == SPAWN_ZONE_TYPES.SAVE_POINT:
		checkpointSprite.visible = true
	else:
		checkpointSprite.visible = false


func _on_PlayerSpawnZone_body_entered(body: Node) -> void:
	if not body is Player: return #do nothing if its not the player
	
	if spawn_zone_type == SPAWN_ZONE_TYPES.SAVE_POINT:
		#we only want to emit this when the player moves over it and it's a dedicated save point
		#emit the save point reached so Events will remember WHICH save room this is
		var new_save_point_path : String = get_parent().filename
		checkpointSprite.play("activated")
		SoundPlayer.play_sound(SoundPlayer.library.CHECKPOINT_ACTIVATE)
		PlayerStats.set_health(PlayerStats.max_health)
		Events.emit_signal("save_point_reached", position, new_save_point_path)
		
		


func _on_checkpointSprite_animation_finished() -> void:
	checkpointSprite.play("default")
