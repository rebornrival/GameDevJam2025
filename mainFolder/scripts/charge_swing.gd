extends ShapeCast2D
var time = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -=delta
	if time <= 0:
		get_parent().freedom()
		queue_free()
	pass
