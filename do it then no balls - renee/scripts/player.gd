extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0

var first_wall = false

var double_jump_unlocked = true
var double_jump = true

var dash_unlocked = true
var is_dashing = false
var dash_timer = .75
var can_dash = true
var curr_dir = 1

var slash_unlocked = true
var is_slashing = false
var slash_timer = 0.5
var can_slash = true

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
			double_jump = true
			can_dash = true
			dash_timer = .75
	elif not is_on_floor():
		velocity.y += 1500*delta
		first_wall = false
	else:
		first_wall = false
		double_jump = true
		if is_dashing == false:
			can_dash = true
			dash_timer = .75
	#jump
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			velocity.x = -1800*curr_dir
			#double_jump = true
			#if you want to give the player the double jump back when they walljump, add double_jump == true here.
		elif double_jump == true and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jump = false
	#left and right
	if direction and is_dashing == false:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/4)
		curr_dir = direction
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#flip the sprite
	if curr_dir == 1:
		$AnimatedSprite2D.set_flip_h(false)
	else:
		$AnimatedSprite2D.set_flip_h(true)
	#dash
	if is_dashing == true:
		while dash_timer >= 0:
			velocity.x += 40*curr_dir
			dash_timer -=delta
	if dash_timer <=0:
		is_dashing = false
	if Input.is_action_just_pressed("dash") and dash_unlocked == true and can_dash == true:
		is_dashing = true
		can_dash = false
	#slash
	if is_slashing == true:
		slash_timer -=delta
		if curr_dir == 1:
			get_child(4).position.x = 20
			get_child(4).get_child(0).set_flip_h(false)
		else:
			get_child(4).position.x = -20
			get_child(4).get_child(0).set_flip_h(true)
	if slash_timer <=0:
		is_slashing = false
		remove_child(get_child(4))
		can_slash = true
	if Input.is_action_just_pressed("hatchet") and slash_unlocked == true and can_slash == true:
		is_slashing = true
		can_slash = false
		slash_timer = 0.5
		add_child(load("res://scenes/la_swing.tscn").instantiate())
	move_and_slide()
