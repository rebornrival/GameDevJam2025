extends Node2D

func _ready():
	add_child(load("res://scenes/fearTutorial.tscn").instantiate())

func load_room(room: String):
	get_child(1).queue_free()
	add_child(load(room).instantiate())
	Globals.cutscenemode = false
	pass
