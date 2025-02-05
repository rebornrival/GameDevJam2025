extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0

var first_wall = false

var double_jump_unlocked = true
var double_jump = true

var dash_unlocked = true
var is_dashing = false
var dash_timer = 1
var can_dash = true

func _physics_process(delta: float) -> void:
	#MOVEMENT CONTROLS
	#gravity
	if is_on_wall() and velocity.y >=0 and not is_on_floor():
		if first_wall == false:
			velocity.y = 0
			first_wall = true
		if first_wall == true:
			velocity.y += 200*delta
			can_dash = true
	elif not is_on_floor():
		velocity.y += 1000*delta
		first_wall = false
	else:
		first_wall = false
		double_jump = true
		if is_dashing == false:
			can_dash = true
			dash_timer = 1
	#jump
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if double_jump == true and not is_on_floor() and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jump = false
	#left and right
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and is_dashing == false:
		velocity.x = direction * SPEED
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#dash
	if is_dashing == true:
		while dash_timer >= 0:
			velocity.x += 200*direction
			dash_timer -=delta
	if dash_timer <=0:
		is_dashing = false
	if Input.is_action_just_pressed("dash") and dash_unlocked == true and can_dash == true:
		is_dashing = true
		can_dash == false
	move_and_slide()
