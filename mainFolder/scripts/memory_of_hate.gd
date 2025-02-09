extends CharacterBody2D

var state = 0
var curr_dir = -1

func _process(delta: float) -> void:
	#state flow
	if state == 0:
		velocity.x = -1*get_parent().get_child(0).velocity.x
		position.x = 1500 - get_parent().get_child(0).position.x
		velocity.y = -1*get_parent().get_child(0).velocity.y
		position.y = get_parent().get_child(0).position.y
		curr_dir = -1 * get_parent().get_child(0).curr_dir
		if position.x < 1000:
			velocity.x = 0
			velocity.y = 100
			state = 1
			Globals.cutscenemode = true
			Globals.endcutsceneafterdialog = false
			Globals.dialog = ["hHere looking for answers, are you?", "ySort of. You… you look like me. Do you have answers?", "hAs if I’d give anything to you willingly!", "hWhy should I help you?"]
	elif state == 1:
		if Globals.dialog.size() == 0:
			state = 2
			add_child(load("res://scenes//hate_dialog_controller.tscn").instantiate())
	elif state == 2:
		if get_child(2).dialog_state == 7:
			remove_child(get_child(2))
			state = 3
	elif state == 3:
		if Globals.dialog.size() == 0:
			state = 4
			Globals.dialog = ["y...You don’t know why you hate me?", "h...", "hI'm sure it was a good reason.", "y...I believe you.", "yI want to figure out that reason too, so we can move on.", "h...", "hOkay."]
	elif state == 4:
		if Globals.dialog.size() == 0:
			velocity.x = -200
			state = 5
	elif state == 5:
		if position.x < 650:
			velocity.x = 0
			state = 6
			Globals.dialog = ["hGo on, then.", "h...", "hI won’t be much help but… at least you’ll figure out what you were feeling then."]
	elif state == 6:
		if Globals.dialog.size() == 0:
			visible = false
			get_parent().get_child(0).get_child(3).modulate = Color (1.0, 0.0, 1.0, 1.0)
			Globals.absorb_timer = 8
			state = 7
	elif state == 7:
		if Globals.absorb_timer < 0:
			get_parent().get_child(0).get_child(3).modulate = Color (1.0, 1.0, 1.0, 1.0)
			Globals.parry_unlocked = true
			Globals.cutscenemode = false
	#animations
	if curr_dir == 1:
		$AnimatedSprite2D.set_flip_h(false)
	else:
		$AnimatedSprite2D.set_flip_h(true)
	if velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.play()
	elif not is_on_floor():
		$AnimatedSprite2D.animation = "down"
		$AnimatedSprite2D.play()
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
	move_and_slide()
