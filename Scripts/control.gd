extends Control

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Hackaton-main/Scenes/underworld.tscn")
	ResourceLoader.load_threaded_request("res://Hackaton-main/Scenes/overworld.tscn")

func _on_texture_button_pressed() -> void:
	pass

func _on_texture_button_4_pressed() -> void:
	LoadingScreen.start_loading(scene_file_path)
	hide()

func _on_texture_button_2_pressed() -> void:
	get_tree().quit()
