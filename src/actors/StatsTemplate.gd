extends Node

signal no_health

export(int) var max_health = 4
onready var health = max_health setget set_health

var has_collected_claws : bool = true #variable to track if the player collected melee indepentent of scenes


#override the default setget so we can do extra logic when we do stuff like PlayerStats.health -= 1
func set_health(newHealth):
	health = newHealth
	if health <= 0:
		emit_signal("no_health")
