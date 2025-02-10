extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		Globals.fear_stop = false
	pass # Replace with function body.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if 'player' in body.name:
		Globals.fear_stop = true
	pass # Replace with function body.
