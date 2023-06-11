extends Node

signal no_health
signal health_changed(newHealth)
signal max_health_changed(newMaxHealth)

export(int) var max_health = 4 setget set_max_health
var health = max_health setget set_health


#override the default setget so we can do extra logic when we do stuff like PlayerStats.health -= 1
func set_health(newHealth):
	health = newHealth
	emit_signal("health_changed", newHealth) #used by the HealthUI to draw correct number of hearts
	if health <= 0:
		emit_signal("no_health")

func restore_health(restoreHP):
	health = min(health + restoreHP, max_health) #dont let health go higher than max

func set_max_health(newMaxHealth): 
	max_health = newMaxHealth
	self.health = min(health, newMaxHealth)
	emit_signal("max_health_changed", newMaxHealth) #used by the HealthUI to draw correct number of hearts


func _ready() -> void:
	self.health = max_health
