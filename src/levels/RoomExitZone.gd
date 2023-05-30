extends Area2D

export(String, FILE, "*.tscn") var target_room_path = ""
#here is a list of all the possible screen transitions. We define them here so we can control it better in the editor
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


func _on_RoomTransitionZone_body_entered(body: Node) -> void:
	if not body is Player: return #if body isn't player, do nothing and end function
	if target_room_path.empty(): return # if transition area doesn't have next scene, don't freak out
	#play the screen transition for the given exit
	ScreenTransitions.play_transition(transition_type)
	#wait for screen transition to fully play and THEN change scenes this uses our custom signal
	yield(ScreenTransitions, "transition_completed") 
	get_tree().change_scene(target_room_path)
