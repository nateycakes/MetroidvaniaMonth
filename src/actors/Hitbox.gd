extends Area2D
class_name Hitbox

#its called hitbox but really its SPECIFICALLY a player-damaging hitbox

func _on_Hitbox_body_entered(body: Node) -> void:
	if body is Player:
			#get_tree().reload_current_scene()
			print("player takes damage")
			
