extends Area2D

var body_to_teleport: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sariel" or body.is_in_group("player"):
		if not SarielHealth.immortality:
			
			# 1. Uzimamo štetu (ovo pokreće animaciju srca)
			if body.has_method("take_damage"):
				body.take_damage()
			
			SarielHealth.set_temporary_immortality(1.0)
			
			if body.has_method("apply_knockback"):
				body.apply_knockback(global_position)
			
			# 2. Ako je zdravlje 0, čekamo animaciju pre teleporta
			if SarielHealth.health <= 0:
				body_to_teleport = body
				# Pozivamo funkciju sa malim zakašnjenjem (deferred)
				call_deferred("teleport_after_delay")

func teleport_after_delay():
	# Čekamo 0.6 sekundi (isto koliko smo stavili u _on_sariel_death)
	# Ovo omogućava animaciji srca da završi pre nego što scena nestane
	await get_tree().create_timer(0.6).timeout
	teleport_and_change_scene()

func teleport_and_change_scene():
	var scene = get_tree().current_scene.scene_file_path
	if is_instance_valid(body_to_teleport):
		if scene == "res://Hackaton-main/Scenes/underworld.tscn":
			body_to_teleport.global_position = Pos.key_last_foundL
		elif scene == "res://Hackaton-main/Scenes/overworld.tscn":
			body_to_teleport.global_position = Pos.key_last_foundD
		
		# Napomena: SarielHealth.reset_health() će uraditi igrač u svom _on_sariel_death
		# Mi samo osvežavamo prikaz nakon što se on desi
		if body_to_teleport.has_method("update_heart_display"):
			body_to_teleport.update_heart_display()
