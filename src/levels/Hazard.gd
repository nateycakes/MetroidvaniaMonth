extends Node2D



func _on_Hitbox_area_entered(area: Area2D) -> void:
	SoundPlayer.play_sound(SoundPlayer.library.FLOOR_DAMAGE)
