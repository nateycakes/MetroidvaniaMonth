extends Area2D



func _on_WinTheGameZone_area_entered(area: Area2D) -> void:
	get_tree().change_scene("res://src/ui/Title Screen.tscn")
