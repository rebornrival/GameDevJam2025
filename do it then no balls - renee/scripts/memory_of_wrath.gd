extends CharacterBody2D

var swing = preload("res://scenes/wrath_swing.tscn")
var charge = preload("res://scenes/charge_swing.tscn")
var direction = 1
var free = true
var SPEED = 500
var recovery_time = 0
var health = 6
var random_movement = [1,1,2,2,2,3,4,5]
var stupid_game
var over = true
var over_timer = 1
var freedom_from_recovery = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recovery_time >= 0:
		recovery_time -= delta
		freedom_from_recovery = false
	if recovery_time <= 0:
		free = true
		freedom_from_recovery = true
	if not is_on_floor():
		velocity.y += 1500*delta
	
	if over_timer >0:
		over_timer-=delta
	elif over_timer <=0:
		over = true
	
	if free == true and over == true:
		stupid_game = random_movement.pick_random()
	#movement
	if stupid_game == 1 and over == true and free == true:
		velocity.x = -direction*SPEED/10
		over = false
		over_timer = 2
	elif stupid_game == 2 and over == true and free == true:
		velocity.x = direction*SPEED/2
		over = false
		over_timer = 1
	elif stupid_game == 3 and over == true and free == true:
		velocity.x = -direction*SPEED/10
		velocity.y -= 700
		over = false
		over_timer = 2
	elif stupid_game == 4 and over == true and free == true:
		velocity.x = direction*SPEED/10
		velocity.y -= 700
		over = false
		over_timer = 2
	elif stupid_game == 5 and over == true and free == true:
		velocity.x = direction*SPEED/10
		velocity.y -= 1000
		over = false
		over_timer = 2
	
	if health <= 0:
		queue_free()
	move_and_slide()

func attack():
	free = false
	var parent = get_node(".")
	var swing_instance = swing.instantiate()
	parent.add_child(swing_instance)
	if direction == 1:
		swing_instance.position.x = 60
		#get_child(4).get_child(0).set_flip_h(false)
	else:
		swing_instance.position.x = -60
		#get_child(4).get_child(0).set_flip_h(true)

func charge_attack():
	free = false
	var parent = get_node(".")
	var charge_instance = charge.instantiate()
	parent.add_child(charge_instance)
	if direction == 1:
		velocity.x += SPEED#move_toward(velocity.x, direction * SPEED*1.5, SPEED/2)
		velocity.y = 0
		charge_instance.position.x = 60
	else:
		velocity.x = -SPEED#move_toward(velocity.x, direction * SPEED, SPEED)
		velocity.y = 0
		charge_instance.position.x = -60

func freedom():
	free = true

func smash():
	health -= 1
	recovery_time = 2
	free = false
	velocity.x = 0

func _on_slash_range_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		direction = 1
		if free == true:
			attack()
	pass # Replace with function body.

func _on_slah_range_left_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		direction = -1
		if free == true:
			attack()
	pass # Replace with function body.

func _on_charge_range_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		direction = 1
		if free == true:
			charge_attack()
	pass # Replace with function body.

func _on_charge_range_left_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		direction = -1
		if free == true:
			charge_attack()
	pass # Replace with function body.

func _on_hitbox_body_entered(body: Node2D) -> void:
	if 'player' in body.name:
		var a = 'a'
		#body.die()
	if 'wrath_tree' in body.name:
		#if free == true:
		smash()
		body.queue_free()
	pass # Replace with function body.
