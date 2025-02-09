extends Sprite2D
func _ready():
	set("theme_override_font_sizes/font_size", 48)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.dialog.size() == 0:
		visible = false
	else:
		visible = true
	pass
