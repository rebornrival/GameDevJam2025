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

var can_land = false
var is_landing = false
var land_timer = 0.36

var is_jumping = false
var jump_timer = 0.3

func _physics_process(delta: float) -> void:
	#MOVEMENT CONTROLS
	#I moved the direction check up a bit b/c I need it to wall jump and to change how we do wall slides.
	var direction := Input.get_axis("ui_left", "ui_right")
	#gravity
	if is_on_wall() and velocity.y >=0 and not is_on_floor() and direction:
		can_land = true
		if first_wall == false:
			velocity.y = 0
			first_wall = true
		if first_wall == true:
			velocity.y += 400*delta
			double_jump = true
			can_dash = true
			dash_timer = .75
	elif not is_on_floor():
		can_land = true
		velocity.y += 1500*delta
		first_wall = false
	else:
		first_wall = false
		double_jump = true
		if is_dashing == false:
			can_dash = true
			dash_timer = .75
		if can_land:
			can_land = false
			is_landing = true
			land_timer = 0.36
	#jump
	if Input.is_action_just_pressed("ui_accept") and not Globals.cutscenemode:
		if is_on_floor():
			is_jumping = true
			jump_timer = 0.3
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			velocity.x = -1800*curr_dir
			#double_jump = true
			#if you want to give the player the double jump back when they walljump, add double_jump == true here.
		elif double_jump == true and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jump = false
	#left and right
	if direction and is_dashing == false and not Globals.cutscenemode:
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
	if Input.is_action_just_pressed("dash") and dash_unlocked == true and can_dash == true and not Globals.cutscenemode:
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
	#jumping timer
	if is_jumping == true:
		jump_timer -=delta
	if jump_timer <=0 and is_jumping:
		is_jumping = false
		velocity.y = JUMP_VELOCITY
	#landing timer
	if is_landing == true:
		land_timer -=delta
	if land_timer <=0:
		is_landing = false
	#animation code
	if is_jumping or velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif is_on_wall() and !is_on_floor():
		$AnimatedSprite2D.animation = "slide"
		$AnimatedSprite2D.play()
	elif !is_on_floor():
		$AnimatedSprite2D.animation = "fall"
		$AnimatedSprite2D.play()
	elif is_landing:
		$AnimatedSprite2D.animation = "land"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif velocity.x == 0:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
	#proof of concept global test dialog, press T to activate.
	if Input.is_action_just_pressed("test"):
		Globals.dialog = ["wHelp.", "hPlease.", "fThis goddamn engine."]
		Globals.cutscenemode = true
	move_and_slide()
