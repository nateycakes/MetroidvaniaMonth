extends CanvasLayer
class_name LoreBook

onready var controlNode : Control = $Control
onready var textBox : DialogueBox = $Control/MarginContainer/SplitScreenContainer/DialogueBox

func _ready() -> void:
	textBox.show_dialogueBox()
