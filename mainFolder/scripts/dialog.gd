extends Label
var textpos = 1
func _ready():
	set("theme_override_font_sizes/font_size", 48)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.dialog.size() == 0:
		visible = false
	elif textpos < Globals.dialog[0].length():
		visible = true
		#Detects the first letter of the string as the color code. My idea is for each character to have its own color code.
		if Globals.dialog[0].substr(0,1) == "y":
			set("theme_override_colors/font_color",Color(0.2,0.2,0.2,1.0))
		elif Globals.dialog[0].substr(0,1) == "h":
			set("theme_override_colors/font_color",Color(1.0,0.2,1.0,1.0))
		elif Globals.dialog[0].substr(0,1) == "w":
			set("theme_override_colors/font_color",Color(1.0,0.2,0.2,1.0))
		elif Globals.dialog[0].substr(0,1) == "f":
			set("theme_override_colors/font_color",Color(1.0,0.8,0.2,1.0))
		elif Globals.dialog[0].substr(0,1) == "n":
			set("theme_override_colors/font_color",Color(1.0,1.0,1.0,1.0))
		textpos += 0.5
		set_text(Globals.dialog[0].substr(1, textpos))
	elif Input.is_action_just_pressed("movedialog"):
		Globals.dialog.remove_at(0)
		textpos = 1
		if Globals.endcutsceneafterdialog:
			Globals.cutscenemode = false
	pass
