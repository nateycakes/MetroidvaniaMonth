tool
extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	PINGPONG
}

export(ANIMATION_TYPE) var animation_type setget set_animation_type
export(float) var speed = 1.0 setget set_speed

onready var animationPlayer = $AnimationPlayer
onready var inactiveTimer = $InactiveTimer
onready var pathFollow2D = $PathFollow2D
onready var hurtboxCollisionShape = $PathFollow2D/Enemy/Hurtbox/CollisionShape2D
onready var hitboxCollisionShape = $PathFollow2D/Enemy/Hitbox/CollisionShape2D

var is_active = true
var saved_animation_position : float = 0.0

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

func activate_collision():
	hurtboxCollisionShape.disabled = false
	hitboxCollisionShape.disabled = false

func deactivate_collision():
	hurtboxCollisionShape.disabled = true
	hitboxCollisionShape.disabled = true

#only the player is masked to this layer, so player will always be the one striking
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	saved_animation_position = animationPlayer.current_animation_position
	animationPlayer.play("Deactivate")
	inactiveTimer.start()
	is_active = false

#after timer finishes, begin the activation animation
func _on_InactiveTimer_timeout() -> void:
	animationPlayer.play("Activate")
	is_active = true

#function called by animation player to transition back to where it was in its previous animation (affects the offset/position)
func activation_finished() -> void:
	play_set_animation(animationPlayer)
	animationPlayer.seek(saved_animation_position)
