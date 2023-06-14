extends CanvasLayer

onready var dialogueBox : DialogueBox = $CenterContainer/DialogueBox


func _ready() -> void:
	dialogueBox.hide()
	Events.connect("jump_ability_collected", self, "_on_jump_ability_collected")
	Events.connect("melee_ability_collected", self, "_on_melee_ability_collected")
	
	

func _on_melee_ability_collected():
	dialogueBox.queue_text("Gained Ability: \n Melee Attack")
	PauseScreen.pause_game()

func _on_jump_ability_collected():
	dialogueBox.queue_text("Gained Ability: \n Double Jump")
	PauseScreen.pause_game()


func _on_DialogueBox_dialogue_finished() -> void:
	dialogueBox.hide_dialogueBox()
	PauseScreen.unpause_game()
