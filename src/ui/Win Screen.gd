extends Control

onready var secretCountLabel : Label = $MarginContainer/VBoxContainer/SecretCountLabel

func _ready() -> void:
	ScreenTransitions.play_transition("DEFAULT_IN")
	MusicPlayer.crossfade_songs(MusicPlayer.library.VICTORY_SCREEN)
	set_secret_count_label()



func set_secret_count_label():
	var secretCount : int = Events.lorebook_entries.size()
	secretCountLabel.text = "You collected: " + str(secretCount) + " / 19 Secrets"
