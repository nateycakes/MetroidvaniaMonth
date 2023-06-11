extends Control

var hearts = 8 setget set_hearts
var max_hearts = 8 setget set_max_hearts


onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

var empty_heart_texture_size = 12
var full_heart_texture_size = 12


#we override the default setget so we can match the amount of hearts the player has whenever Godot updates this value
#so whenever we run health -= 1 for example, this will fire
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts) #health cannot go beyond these bounds
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * (full_heart_texture_size / 2) #we're counting in half hearts

#override setget
func set_max_hearts(value):
	max_hearts = max(value, 1) #health cannot be set less than 1
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * (full_heart_texture_size / 2) #we're using half hearts


func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")




