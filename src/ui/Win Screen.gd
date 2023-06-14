extends Control

func _ready() -> void:
	ScreenTransitions.play_transition("DEFAULT_IN")
	MusicPlayer.crossfade_songs(MusicPlayer.library.VICTORY_SCREEN)
