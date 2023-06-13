extends HBoxContainer

onready var jumpAbilityIcon : TextureRect = $JumpAbilityIcon
onready var meleeAbilityIcon : TextureRect = $MeleeAbilityIcon

func _ready() -> void:
	jumpAbilityIcon.visible = Events.has_collected_double_jump
	meleeAbilityIcon.visible = Events.has_collected_claws
	Events.connect("jump_ability_collected", self, "_on_jump_collected")
	Events.connect("melee_ability_collected", self, "_on_melee_collected")


func _on_melee_collected():
	meleeAbilityIcon.visible = true

func _on_jump_collected():
	jumpAbilityIcon.visible = true
