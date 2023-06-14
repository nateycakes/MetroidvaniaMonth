extends Control
class_name DialogueBox

signal dialogue_finished

enum states {
	READY,
	READING,
	FINISHED
}

const TEXT_DISPLAY_SPEED = 0.05

onready var textArea : RichTextLabel = $BodyBackground/MarginContainer/textArea
#onready var dialogueContainer : CenterContainer = $DialogueBoxContainer
onready var textTween : Tween = $Tween
onready var confirmIcon : TextureButton = $BodyBackground/TextureButton

var current_state = states.READY
var text_queue = [] #we'll push/pop lines to display here

func _ready() -> void:
	hide_dialogueBox()
	confirmIcon.hide()


func _process(delta: float) -> void:
	match current_state:
		states.READY:
			if !text_queue.empty():
				display_text()
		states.READING:
			if Input.is_action_just_pressed("ui_accept"): #display the rest of the text, let it skip ahead
				textArea.percent_visible = 1.0
				textTween.stop_all()
				confirmIcon.show()
				change_state(states.FINISHED)
		states.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				#done displaying current text and user has hit confirm, we are ready for next text
				change_state(states.READY)
				clear_text()
				confirmIcon.hide()
				if text_queue.empty(): 
					emit_signal("dialogue_finished")



func queue_text(next_text):
	text_queue.push_back(next_text)


func show_dialogueBox():
	self.show()

func hide_dialogueBox():
	textArea.text = ""
	confirmIcon.hide()
	self.hide()

func clear_text():
	textArea.text = ""

func hide_button():
	confirmIcon.hide()

func show_button():
	confirmIcon.show()

func display_text():
	var text_input = text_queue.pop_front()
	textArea.text = text_input
	textArea.percent_visible = 0.0
	change_state(states.READING)
	show_dialogueBox()
	#interpolate "percent visible" from 0 - 1 at a rate of the length of text muliplied by the display speed
	#allows variable length while maintaining constant speed (instead of using animationPlayer)
	textTween.interpolate_property(textArea, "percent_visible", 0.0, 1.0, len(text_input)* TEXT_DISPLAY_SPEED, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTween.start()


func _on_Tween_tween_all_completed() -> void:
	confirmIcon.show()
	change_state(states.FINISHED)

func change_state(next_state):
	current_state = next_state
#	match current_state:
#		states.READY:
#			print("Changing to Ready state")
#		states.READING:
#			print("Changing to Reading state")
#		states.FINISHED:
#			print("Changing to Finished state")






