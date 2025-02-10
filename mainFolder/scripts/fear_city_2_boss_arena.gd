extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"evil wall/AnimationPlayer".play("RESET")
	$"evil wall/CollisionShape2D".disabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.fear_stop == false:
		$Path2D/PathFollow2D.progress += 350*delta
	
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		$"evil wall".visible = true
		$"evil wall/AnimationPlayer".play("evil wall")
		$"evil wall/CollisionShape2D".disabled = false
	pass # Replace with function body.
