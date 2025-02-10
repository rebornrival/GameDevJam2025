extends Node2D

func load_room(room: String):
	remove_child(get_child(0))
	add_child(load(room).instantiate())
	Globals.cutscenemode = false
	pass
