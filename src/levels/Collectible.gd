extends Node2D
class_name Collectible


enum COLLECTIBLE_TYPE {
	DOUBLEJUMP,
	HEALTH,
	LOGBOOK
}

export(COLLECTIBLE_TYPE) var collectible_type setget set_collectible_type
onready var hitbox = $CollectibleHitbox




func increase_double_jump_count(player: Player):
	player.moveData.DOUBLE_JUMP_COUNT += 1

func set_collectible_type(value):
	collectible_type = value

func _on_CollectibleHitbox_body_entered(body: Node) -> void:
	if body is Player:
		match collectible_type:
			COLLECTIBLE_TYPE.DOUBLEJUMP:
				increase_double_jump_count(body)
			COLLECTIBLE_TYPE.HEALTH:
				pass
			COLLECTIBLE_TYPE.LOGBOOK:
				pass
		queue_free()
