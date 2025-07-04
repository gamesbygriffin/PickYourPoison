extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var coin_particle: PackedScene

var max_speed = 300
var acceleration = 2000
var friction = 5000

var dash_speed = 1000
var dash_duration = 0.7
var dash_timer = 0.0
var is_dashing = false

var invincible = false
var target_scale = Vector2(0.1, 0.1)
var in_cannon = false
var current_cannon
var hat_number
var space_key = false

var skew_amount = -0.0
var target_skew = 0.0

func _ready():
	hat_number = 30
	hide()
	$AnimationPlayer.get_animation("idle").loop = true
	add_to_group("player_group")

func _on_hud_start_game():
	show()
	$HatManager.set_hat(hat_number)
	position = Vector2(963,547)
	max_speed = 300
	acceleration = 2000
	friction = 5000
	dash_speed = 1000
	dash_duration = 0.7
	dash_timer = 0.0
	is_dashing = false
	invincible = false
	target_scale = Vector2(0.1, 0.1)

func _process(delta):
	var screen_size = get_viewport().get_visible_rect().size
	
	if Global.in_game == true:
		invincible = false
	elif Global.in_game == false:
		invincible = true
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0

func _physics_process(delta): #Use lerp to add skew right and left and on dash make it more extreme
	if Global.in_game or in_cannon == true:
		space_key = false
		var direction = Vector2.ZERO
		if dash_timer > 0:
			dash_timer -= delta
			is_dashing = true
		else:
			is_dashing = false
			
		if Input.is_action_pressed("player_right"):
			direction.x += 1
			sprite.animation = "right"
		if Input.is_action_pressed("player_left"):
			direction.x -= 1
			sprite.animation = "left"
		if Input.is_action_pressed("player_down"):
			direction.y += 1
			sprite.animation = "down"
		if Input.is_action_pressed("player_up"):
			direction.y -= 1
			sprite.animation = "up"
		
		if Input.is_action_just_pressed("player_dash") and not is_dashing:
			dash_timer = dash_duration
			velocity = direction.normalized() * dash_speed
		if direction.length() > 0 and not is_dashing:
			direction = direction.normalized()
			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		elif direction.length() == 0:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if is_dashing:
			#invincible = true
			if velocity.length() > dash_speed:
				velocity = velocity.move_toward(Vector2.ZERO,  delta)
			else:
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		else:
			pass
			#invincible = false
		if velocity == Vector2.ZERO:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.stop()
		move_and_slide()
		#var distance = position.y
		if direction.x != 0:
			target_skew = skew_amount * -direction.x
		else:
			target_skew = 0
		if is_dashing:
			target_skew *= 2
		skew = lerp(float(skew), float(target_skew), 0.1)
		#var scale_factor = 0.9 + (distance/5 * 0.001)
		#scale = Vector2(scale_factor, scale_factor)
	
	if Input.is_action_just_pressed("player_dash"):
		space_key = true
	if in_cannon == true and space_key == true:
		in_cannon = false
	if in_cannon == true:
		if current_cannon == null:
			return
		position = current_cannon.get_node("Rotatable/PlayerMarker").global_position
		rotation = current_cannon.cannon_direction.angle() - deg_to_rad(90)
		sprite.animation = "down"
	else:
		rotation = deg_to_rad(0)


"""
	var direction = Vector2.ZERO
	if dash_timer > 0:
		dash_timer -= delta
		is_dashing = true
	else:
		is_dashing = false
		
	if Input.is_action_pressed("player_right"):
		direction.x += 1
		sprite.animation = "right"
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
		sprite.animation = "left"
	if Input.is_action_pressed("player_down"):
		direction.y += 1
		sprite.animation = "down"
	if Input.is_action_pressed("player_up"):
		direction.y -= 1
		sprite.animation = "up"
	if Input.is_action_just_pressed("player_dash") and not is_dashing:
		dash_timer = dash_duration
		velocity = direction.normalized() * dash_speed
	if direction.length() > 0 and not is_dashing:
		direction = direction.normalized()
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	elif direction.length() == 0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if is_dashing:
		#invincible = true
		if velocity.length() > dash_speed:
			velocity = velocity.move_toward(Vector2.ZERO,  delta)
		else:
			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		pass
		#invincible = false
	move_and_slide()
	var distance = position.y
	var scale_factor = 0.9 + (distance/5 * 0.001)
	scale = Vector2(scale_factor, scale_factor)
	"""

func _on_area_2d_area_entered(area):
	if area.is_in_group("cannon_group") and is_dashing == true and in_cannon == false:
		position = area.get_node("Rotatable/PlayerMarker").global_position
		current_cannon = area
		in_cannon = true
		
	if area.is_in_group("money_group"):
		var particle = coin_particle.instantiate() as RigidBody2D
		particle.position = $ParticlePoint.global_position
		if area.money_type == "roll":
			Global.cir_money += 1
			particle.sprite_number = 1
		elif area.money_type == "fall":
			Global.tri_money += 1
			get_tree().get_first_node_in_group("end_screen_group").money_tracker += 1
			particle.sprite_number = 2
		elif area.money_type == "mult":
			Global.tri_money *= 1.5
			get_tree().get_first_node_in_group("end_screen_group").money_tracker *= 1.5
			particle.sprite_number = 3
		get_parent().add_child(particle)
	if invincible == false:
		if area.is_in_group("enemy_group"):
			Global.player_hp -= 1
			get_tree().get_first_node_in_group("end_screen_group").hp_tracker += 1

"""

extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

const max_speed = 400
const smoothing = 25

func _ready():
	add_to_group("player_group")

func _process(delta):
	if Input.is_action_pressed("player_right"):
		sprite.animation = "right"
	if Input.is_action_pressed("player_left"):
		sprite.animation = "left"
	if Input.is_action_pressed("player_down"):
		sprite.animation = "down"
	if Input.is_action_pressed("player_up"):
		sprite.animation = "up"
	
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * smoothing))
	move_and_slide()

func get_movement_vector():	
	var x_movement = Input.get_action_strength("player_right") - Input.get_action_strength("player_left") 
	var y_movement = Input.get_action_strength("player_down") - Input.get_action_strength("player_up") 
	
	return Vector2(x_movement, y_movement)
"""
