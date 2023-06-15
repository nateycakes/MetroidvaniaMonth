extends Node2D
class_name Collectible

signal collected(type) #this should be listened to by some game manager object, not sure if I'll have time to implement




enum COLLECTIBLE_TYPE {
	DOUBLEJUMP,
	CLAWS,
	HEALTH,
	LOGBOOK
}

export(COLLECTIBLE_TYPE) var collectible_type = COLLECTIBLE_TYPE.DOUBLEJUMP setget set_collectible_type
export(int) var lore_id = 0
onready var animatedSprite = $AnimatedSprite

var healthPowerupValue = 1

func _ready() -> void:
	set_correct_icon(collectible_type)


func acquire_double_jump(player: Player):
	player.moveData.DOUBLE_JUMP_COUNT = 1
	Events.has_collected_double_jump = true

func set_collectible_type(value):
	collectible_type = value


func get_collected(sound):
	SoundPlayer.play_sound(sound)
	queue_free()


func set_correct_icon(type):
	match type:
		COLLECTIBLE_TYPE.CLAWS:
			animatedSprite.play("meleeAbility")
		COLLECTIBLE_TYPE.DOUBLEJUMP:
			animatedSprite.play("doubleJump")
		COLLECTIBLE_TYPE.HEALTH:
			animatedSprite.play("healthPickup")
		COLLECTIBLE_TYPE.LOGBOOK:
			animatedSprite.play("logbook")

# --------- SIGNALS -----------------

func _on_Hurtbox_body_entered(body: Node) -> void:
	if body is Player:
		var sfx : Resource
		match collectible_type:
			COLLECTIBLE_TYPE.DOUBLEJUMP:
				emit_signal("collected", COLLECTIBLE_TYPE.DOUBLEJUMP)
				acquire_double_jump(body)
				sfx = SoundPlayer.library.PICKUP_POWERUP
				Events.emit_signal("jump_ability_collected")
			COLLECTIBLE_TYPE.HEALTH:
				sfx = SoundPlayer.library.PICKUP_HEALTH
				emit_signal("collected", COLLECTIBLE_TYPE.HEALTH)
				#don't let us send anything bigger than the max HP or the UI will look weird
				PlayerStats.set_health(min(PlayerStats.health + 1, PlayerStats.max_health))
			COLLECTIBLE_TYPE.LOGBOOK:
				sfx = SoundPlayer.library.PICKUP_DISC
				Events.add_lorebook_entry(lore_id)
				emit_signal("collected", COLLECTIBLE_TYPE.LOGBOOK)
			COLLECTIBLE_TYPE.CLAWS:
				Events.has_collected_claws = true
				body.has_melee_ability = true #cheap way of doing it without game manager node
				sfx = SoundPlayer.library.PICKUP_POWERUP
				emit_signal("collected", COLLECTIBLE_TYPE.CLAWS)
				Events.emit_signal("melee_ability_collected")
		get_collected(sfx)
