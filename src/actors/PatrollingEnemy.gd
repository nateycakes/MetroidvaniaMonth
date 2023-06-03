tool
extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	PINGPONG
}

export(ANIMATION_TYPE) var animation_type setget set_animation_type
export(float) var speed = 1.0 setget set_speed

onready var animationPlayer = $AnimationPlayer


func _ready():
	play_set_animation(animationPlayer)


func set_speed(value):
	speed = value
	var targetAnimationPlayer = find_node("AnimationPlayer")
	if targetAnimationPlayer:
		targetAnimationPlayer.playback_speed = speed

func reached_endpoint():
	#do cool stuff
	pass


func set_animation_type(newAnimation):
	animation_type = newAnimation
	#need to get the animationPlayer this way bc tool mode doesn't use the _ready() func
	#and the animationPlayer node might not be fully loaded yet
	var targetAnimationPlayer = find_node("AnimationPlayer")
	if targetAnimationPlayer:
		play_set_animation(targetAnimationPlayer)

func play_set_animation(targetAnimationPlayer):
	match animation_type:
		ANIMATION_TYPE.LOOP: targetAnimationPlayer.play("MoveAlongPathLoop")
		ANIMATION_TYPE.PINGPONG: targetAnimationPlayer.play("MoveAlongPathPingPong")


