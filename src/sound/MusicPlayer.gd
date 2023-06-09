extends Node

onready var library: MusicLibrary = preload("res://src/sound/MusicLibrary.tres") as MusicLibrary

#saved as dictionaries for flexibility also the OG implementation (ty Sam!) had tween nodes. I'm leaving it like
#this in case we want to add more functionality to each track (filters or something maybe?)

onready var primary_track = { 
	music_player = $MusicPlayers/PrimaryTrack
}

onready var secondary_track = {
	music_player = $MusicPlayers/SecondaryTrack
}

onready var animationPlayer = $AnimationPlayer
var current_bgm : String = ""

func _ready() -> void:
	pass
	#initialize the current track variable
	#PLAY THE FIRST SONG OF THE GAME HERE SINCE ITS LOADED FIRST
	#primary_track.music_player.play(library.STREETS)


func determine_active_track():
	if secondary_track.music_player.playing:
		return secondary_track
	else:
		return primary_track


func crossfade_songs(nextSong):
	#figure our which of our tracks are playing
	var active_track = determine_active_track()
	var inactive_track
	if active_track == primary_track:
		inactive_track = secondary_track
	else:
		inactive_track = primary_track
	
	#set the next song to start
	inactive_track.music_player.stream = nextSong
	inactive_track.music_player.play()
	
	#use animation player to tween volume for us
	if active_track == primary_track: 
		animationPlayer.play("FadePrimaryOutSecondaryIn")
	else:
		animationPlayer.play("FadeSecondaryOutPrimaryIn")
	
