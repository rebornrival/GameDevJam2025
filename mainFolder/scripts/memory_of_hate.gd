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
