extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0

var double_jump_unlocked = false
var double_jump = true

var dash_unlocked = true
var is_dashing = false
var dash_timer = .1
var can_dash = true

func _physics_process(delta: float) -> void:
	#MOVEMENT CONTROLS
	#gravity
	if is_on_wall() and velocity.y >=0 and not is_on_floor():
		velocity.y += 200*delta
	elif not is_on_floor():
		velocity.y += 1000*delta
	else:
		double_jump = true
	#jump
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if double_jump == true and not is_on_floor() and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jump = false
	#left and right
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#dash
	if Input.is_action_just_pressed("dash"):
		velocity.x = 3000*direction
		is_dashing = true
		
	move_and_slide()
