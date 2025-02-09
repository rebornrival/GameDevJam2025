extends Node2D
#if we can parry, it won't load Hate.#
func _ready() -> void:
	Globals.mincamx = -1000
	$player.position.x = -1000
	pass # Replace with function body.
