extends StaticBody2D

onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D
onready var physicsCollisionShape = $CollisionShape2D
onready var animatedSprite = $AnimatedSprite


enum doorStates {
	OPEN,
	CLOSED
}

var state = doorStates.CLOSED

func _ready() -> void:
	#in case we retain state at some point
	match state:
		doorStates.OPEN:
			animatedSprite.play("OPEN")
		doorStates.CLOSED:
			animatedSprite.play("CLOSED")

#only player is masking to this layer, so no need to test if its the player
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	hurtboxCollisionShape.disabled = true
	physicsCollisionShape.disabled = true
	animatedSprite.play("OPEN")
	state = doorStates.OPEN
