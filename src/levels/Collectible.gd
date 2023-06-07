extends Node2D
class_name Collectible


enum COLLECTIBLE_TYPE {
	DOUBLEJUMP,
	CLAWS,
	HEALTH,
	LOGBOOK
}

export(COLLECTIBLE_TYPE) var collectible_type = COLLECTIBLE_TYPE.DOUBLEJUMP setget set_collectible_type
#onready var animationPlayer = $AnimationPlayer


func _ready() -> void:
	pass
	#animationPlayer.play("Idle")


func increase_double_jump_count(player: Player):
	player.moveData.DOUBLE_JUMP_COUNT += 1

func set_collectible_type(value):
	collectible_type = value


func get_collected(sound):
	print("collectible collected")
	SoundPlayer.play_sound(sound)
	queue_free()




# --------- SIGNALS -----------------

func _on_Hurtbox_body_entered(body: Node) -> void:
	if body is Player:
		var sfx : Resource
		match collectible_type:
			COLLECTIBLE_TYPE.DOUBLEJUMP:
				increase_double_jump_count(body)
				sfx = SoundPlayer.library.PICKUP_POWERUP
			COLLECTIBLE_TYPE.HEALTH:
				sfx = SoundPlayer.library.PICKUP_HEALTH
			COLLECTIBLE_TYPE.LOGBOOK:
				sfx = SoundPlayer.library.PICKUP_DISC
			COLLECTIBLE_TYPE.CLAWS:
				Events.player_collected_claws = true
		get_collected(sfx)
