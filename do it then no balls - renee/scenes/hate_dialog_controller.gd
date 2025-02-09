extends Node2D
var dialog_state = 0
var kill_player = false
var num_options = 3
var option_selected = 1

func _ready():
	$OptionLayer/Dialog1.set("theme_override_font_sizes/font_size", 36)
	$OptionLayer/Dialog2.set("theme_override_font_sizes/font_size", 36)
	$OptionLayer/Dialog3.set("theme_override_font_sizes/font_size", 36)
	pass

func _process(delta):
	Globals.cutscenemode = true
	if Globals.dialog.size() > 0:
		visible = false
		option_selected = 1
	elif kill_player or dialog_state == 7:
		$OptionLayer.visible = false
		visible = false
	else:
		visible = true
		if dialog_state == 0:
			num_options = 3
			$OptionLayer/Dialog1.set_text("Why shouldn't you?")
			$OptionLayer/Dialog2.set_text("I want to atone.")
			$OptionLayer/Dialog3.set_text("If you don't, you'll be all alone.")
		elif dialog_state == 1:
			num_options = 3
			$OptionLayer/Dialog1.set_text("That's your job to tell me.")
			$OptionLayer/Dialog2.set_text("Of course I know.")
			$OptionLayer/Dialog3.set_text("I don't, but I can tell it was horrible.")
		elif dialog_state == 2:
			num_options = 3
			$OptionLayer/Dialog1.set_text("Kinda?")
			$OptionLayer/Dialog2.set_text("No.")
			$OptionLayer/Dialog3.set_text("You’re talking a lot of shit for someone who is a memory of me who also allegedly did this thing.")
		elif dialog_state == 3:
			num_options = 3
			$OptionLayer/Dialog1.set_text("I need your help to figure out what I did.")
			$OptionLayer/Dialog2.set_text("I have no idea.")
			$OptionLayer/Dialog3.set_text("I need to absorb you.")
		elif dialog_state == 4:
			num_options = 3
			$OptionLayer/Dialog1.set_text("That's your job to tell me.")
			$OptionLayer/Dialog2.set_text("I killed Gisei.")
			$OptionLayer/Dialog3.set_text("I don't know.")
		elif dialog_state == 5:
			num_options = 2
			$OptionLayer/Dialog1.set_text("Can I have a cookie?")
			$OptionLayer/Dialog2.set_text("No. I want to come to terms with what I did.")
		elif dialog_state == 6:
			num_options = 3
			$OptionLayer/Dialog1.set_text("Can I have a cookie?")
			$OptionLayer/Dialog2.set_text("No. I want to come to terms with what I did.")
		else:
			visible = false
			pass
		if option_selected == 1:
			$OptionLayer/Dialog1.set("theme_override_colors/font_color",Color(0.2,0.2,0.2,1.0))
			$OptionLayer/Dialog2.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
			$OptionLayer/Dialog3.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
		elif option_selected == 2:
			$OptionLayer/Dialog1.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
			$OptionLayer/Dialog2.set("theme_override_colors/font_color",Color(0.2,0.2,0.2,1.0))
			$OptionLayer/Dialog3.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
		elif option_selected == 3:
			$OptionLayer/Dialog1.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
			$OptionLayer/Dialog2.set("theme_override_colors/font_color",Color(0.6,0.6,0.6,1.0))
			$OptionLayer/Dialog3.set("theme_override_colors/font_color",Color(0.2,0.2,0.2,1.0))
		if Input.is_action_just_pressed("ui_left"):
			option_selected -= 1
			if option_selected == 0:
				option_selected = 1
		if Input.is_action_just_pressed("ui_right"):
			option_selected += 1
			if option_selected > num_options:
				option_selected = num_options
		
		if Input.is_action_just_pressed("movedialog"):
			visible = false
			if dialog_state == 0:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hWhy shouldn’t I?", "hHah.", "hYou're a monster, you don't deserve closure."]
				elif option_selected == 2:
					Globals.dialog = ["hHah.", "hGood one, amnesiac.", "hDo you even know what you're trying to atone for?"]
				elif option_selected == 3:
					kill_player = true
					Globals.dialog = ["hFine by me.", "hBetter than being with someone as abhorrent as you."]
			elif dialog_state == 1:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hNot a chance", "hI don't owe anything to you."]
				elif option_selected == 2:
					kill_player = true
					Globals.dialog = ["hYou can't lie to me, idiot.", "hYou haven't changed a bit."]
				elif option_selected == 3:
					Globals.dialog = ["hNo shit.", "hAnd you think a sorry is going to miraculously fix things?"]
			elif dialog_state == 2:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hWere you born yesterday?", "hLet me tell you something.", "hYour hollow words mean nothing."]
				elif option_selected == 2:
					Globals.dialog = ["hSo you still have a couple neurons firing in there.", "hWhat's you're plan, buddy?"]
				elif option_selected == 3:
					kill_player = true
					Globals.dialog = ["hYou know what?", "hI'm hearing you out and your instinct is to deflect?", "hGo fuck yourself, asshole."]
			elif dialog_state == 3:
				if option_selected == 1:
					Globals.dialog = ["hYou really think I know?", "h...I mean that I'd help you?", "h..."]
					dialog_state += 3
				elif option_selected == 2:
					kill_player = true
					Globals.dialog = ["hOf course you don't", "hYou never have anything planned through."]
				elif option_selected == 3:
					kill_player = true
					Globals.dialog = ["hWooooooah there.", "hNot a chance", "hYou're still a monster, even if you're self-aware."]
			elif dialog_state == 4:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hNot a chance", "hI don't owe anything to you."]
				elif option_selected == 2:
					Globals.dialog = ["hWooooow, our amnesiac remembers something.", "hYou want a cookie?"]
				elif option_selected == 3:
					kill_player = true
					Globals.dialog = ["hFigure it out, then.", "hYou'll get no help from me."]
			elif dialog_state == 5:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hI was joking.", "hThere are no cookies for monsters like you."]
				elif option_selected == 2:
					Globals.dialog = ["hWhat's there to come to terms with?", "hYou killed them."]
			elif dialog_state == 6:
				if option_selected == 1:
					kill_player = true
					Globals.dialog = ["hAnd?", "hWhat does that change?", "hYou still killed them."]
				elif option_selected == 2:
					kill_player = true
					Globals.dialog = ["h...", "hI'm disappointed, but not suprised.", "hYou really are a monster."]
				elif option_selected == 3:
					Globals.dialog = ["hWhat... what do you mean by that?"]
			dialog_state += 1
