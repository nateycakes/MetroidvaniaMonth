extends CanvasLayer

signal transition_completed

onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func play_transition(animationName):
	animationPlayer.play(animationName)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("transition_completed")
