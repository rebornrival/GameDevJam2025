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
	#I moved the direction check up a bit b/c I need it to wall jump and to change how we do wall slides.
	var direction := Input.get_axis("ui_left", "ui_right")
	#gravity
	if is_on_wall() and velocity.y >=0 and not is_on_floor() and direction:
		if first_wall == false:
			velocity.y = 0
			first_wall = true
		if first_wall == true:
			velocity.y += 400*delta
			can_dash = true
	elif not is_on_floor():
		velocity.y += 1500*delta
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
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			velocity.x = -1800*direction
			#if you want to give the player the double jump back when they walljump, add double_jump == true here.
		elif double_jump == true and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jump = false
	#left and right
	if direction and is_dashing == false:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/4)
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#dash
	if is_dashing == true:
		while dash_timer >= 0:
			velocity.x += 40*direction
			dash_timer -=delta
	if dash_timer <=0:
		is_dashing = false
	if Input.is_action_just_pressed("dash") and dash_unlocked == true and can_dash == true:
		is_dashing = true
		can_dash == false
	move_and_slide()
