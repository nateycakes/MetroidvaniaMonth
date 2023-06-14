extends Control

func _ready() -> void:
	Events.gameStart = false
	ScreenTransitions.play_transition("DEFAULT_IN")
	MusicPlayer.crossfade_songs(MusicPlayer.library.TITLE_SCREEN)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			start_game()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_game()


func start_game():
	Events.gameStart = true
	ScreenTransitions.play_transition("DEFAULT_OUT")
	yield(ScreenTransitions, "transition_completed")
	get_tree().change_scene("res://src/levels/build/StartRoom.tscn")
