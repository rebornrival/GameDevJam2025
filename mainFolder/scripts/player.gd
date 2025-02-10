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
var slash_timer = 1
var can_slash = true

var can_land = false
var is_landing = false
var land_timer = 0.36

var is_jumping = false
var jump_timer = 0.1
var parry_unlocked = true

var is_parrying = false
var parry_timer = 2
var can_parry = true

var current_spawn = 'respawnNodes/respawnNode'

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
			jump_timer = 0.1
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			velocity.x = -1800*curr_dir
			#double_jump = true
			#if you want to give the player the double jump back when they walljump, add double_jump == true here.
		elif double_jump == true and Globals.double_jump_unlocked == true:
		#elif double_jump == true and double_jump_unlocked == true:
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
		velocity.x = curr_dir * (SPEED + 1000*dash_timer)
		dash_timer -=delta
		if is_on_wall():
			is_dashing = false
			velocity.x = -1*curr_dir * SPEED
	if dash_timer <=0:
		is_dashing = false
	if Input.is_action_just_pressed("dash") and Globals.dash_unlocked == true and can_dash == true and not Globals.cutscenemode:
	#if Input.is_action_just_pressed("dash") and dash_unlocked == true and can_dash == true and not Globals.cutscenemode:
		is_dashing = true
		can_dash = false
	#slash
	if is_slashing == true:
		slash_timer -=delta
		if curr_dir == 1:
			get_child(4).position.x = 20
		else:
			get_child(4).position.x = -20
	if slash_timer <=0:
		is_slashing = false
		remove_child(get_child(4))
		can_slash = true
	if Input.is_action_just_pressed("hatchet") and Globals.slash_unlocked == true and can_slash == true:
	#if Input.is_action_just_pressed("hatchet") and slash_unlocked == true and can_slash == true:
		is_slashing = true
		can_slash = false
		slash_timer = 1
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
	#parrying code. Note that parries will have to be handled by the attacker checking the is_parrying tag
	if is_parrying == true:
		velocity.x = 0
		parry_timer -=delta
	if parry_timer <=1:
		is_parrying = false
		parry_timer-= delta
	if parry_timer <= 0:
		can_parry = true
	if Input.is_action_just_pressed("parry") and Globals.parry_unlocked == true and can_parry == true and not Globals.cutscenemode:
	#if Input.is_action_just_pressed("parry") and parry_unlocked == true and can_parry == true and not Globals.cutscenemode:
		is_parrying = true
		parry_timer = 2.0
		can_parry = false
	
	if Globals.absorb_timer > 0:
		Globals.absorb_timer -= delta
	#animation code
	if Globals.absorb_timer > 0:
		$AnimatedSprite2D.animation = "merge"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif is_slashing:
		$AnimatedSprite2D.animation = "slash"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif is_parrying:
		if Globals.slash_unlocked:
		#if slash_unlocked:
			$AnimatedSprite2D.animation = "parry_axe"
			if $AnimatedSprite2D.frame == 0:
				$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.animation = "parry_debris"
			if $AnimatedSprite2D.frame == 0:
				$AnimatedSprite2D.play()
	elif is_dashing:
		$AnimatedSprite2D.animation = "dash"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif is_jumping or velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
	elif (is_on_wall() and !is_on_floor()):
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
		add_child(load("res://scenes/hate_dialog_controller.tscn").instantiate())
	#Respawn bullshit
	
	move_and_slide()

func respawn():
	global_transform = get_parent().get_node(current_spawn).global_transform

func _on_area_2d_area_entered(area: Area2D) -> void:
	if "respawn" in area.name:
		current_spawn = area.name
	pass # Replace with function body.
