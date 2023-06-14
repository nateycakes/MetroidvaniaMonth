extends Control

var game_paused : bool = false

onready var canvasLayer : CanvasLayer = $CanvasLayer
onready var screenDarkenRect : ColorRect = $CanvasLayer/ScreenDarkenRect
onready var pauseTimer : Timer = $pauseTimer


func _ready() -> void:
	screenDarkenRect.visible = false



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused #toggle the pause state
		#match all items to pause state
		get_tree().paused = new_pause_state
		Events.gamePaused = new_pause_state
		screenDarkenRect.visible = new_pause_state

func on_demand_pause(length):
	pauseTimer.wait_time = length
	pauseTimer.start()
	get_tree().paused = true

func pause_game():
	get_tree().paused = true
	Events.gamePaused = true
	game_paused = true
	screenDarkenRect.visible = true

func unpause_game():
	get_tree().paused = false
	Events.gamePaused = false
	game_paused = false
	screenDarkenRect.visible = false

func _on_pauseTimer_timeout() -> void:
	get_tree().paused = false
