extends Camera2D

func _physics_process(delta: float) -> void:
	limit_bottom = Globals.maxcamy
	limit_top = Globals.mincamy
	limit_left = Globals.mincamx
	limit_right = Globals.maxcamx
