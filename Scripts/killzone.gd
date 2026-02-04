extends Area2D

var body_to_teleport: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sariel" or body.is_in_group("player"):
		# Pozivamo funkciju na igraču koja brine o animaciji i oduzimanju HP-a
		if body.has_method("take_damage"):
			body.take_damage()
		
		body_to_teleport = body
		call_deferred("teleport_and_change_scene")

func teleport_and_change_scene():
	var scene = get_tree().current_scene.scene_file_path
	if is_instance_valid(body_to_teleport):
		if scene == "res://Hackaton-main/Scenes/underworld.tscn":
			body_to_teleport.global_position=Pos.key_last_foundL
			print("scena je under")
		elif scene == "res://Hackaton-main/Scenes/overworld.tscn":
			print("scena je over")
			body_to_teleport.global_position = Pos.key_last_foundD
	if SarielHealth.health <= 0:
		SarielHealth.reset_health()
		
