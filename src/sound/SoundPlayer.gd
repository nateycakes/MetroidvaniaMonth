extends Node

onready var audioPlayers: = $AudioPlayers
onready var library: SoundLibrary = preload("res://src/sound/SoundLibrary.tres") as SoundLibrary



func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
	
