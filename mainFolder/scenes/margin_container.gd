extends MarginContainer

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fearTutorial.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
