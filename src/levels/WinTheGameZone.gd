extends Area2D


func _on_WinTheGameZone_body_entered(body: Node) -> void:
	if body is Player:
		SoundPlayer.play_sound(SoundPlayer.library.CHECKPOINT_FINAL)
		get_tree().change_scene("res://src/ui/Win Screen.tscn")
