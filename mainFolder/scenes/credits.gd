extends Control

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
