extends CharacterBody2D

@export var bullet_scene: PackedScene 
@export var bomb_scene: PackedScene
@export var cannon_scene: PackedScene
@export var max_health := 100

var set_moves = ["shrapnel","bomb","shotgun","spray"]
var set_wait = [2.5,1.9,2.8,2.5]
var turret_direction
var move_numbers = [0,1,2,3]
var rotation_speed := 3.0

@onready var health_bar = $HealthBar

var active_boss
var current_health := max_health
var call_count = 0 #detect double end

var target_position: Vector2
var moving_x := false
var speed := 120.0
var start_moving = false
var target_angle

func _ready():
	active_boss = false
	add_to_group("tank_boss_group")
	hide()
	#boss_start()

func _process(delta):
	if active_boss == true:
		var player = get_tree().get_first_node_in_group("player_group")
		var to_player = player.global_position - $TurretSprite.global_position
		var target_rotation = to_player.angle() + deg_to_rad(90)
		$TurretSprite.rotation = lerp_angle($TurretSprite.rotation,target_rotation,rotation_speed * delta)
		turret_direction = Vector2.RIGHT.rotated($TurretSprite.rotation)
		if start_moving == false:
			return
		if moving_x:
			target_angle = deg_to_rad(90)
			position.x = move_toward(position.x, target_position.x, speed * delta)
			if is_equal_approx(position.x, target_position.x):
				moving_x = false 
		else:
			target_angle = deg_to_rad(0)
			position.y = move_toward(position.y, target_position.y, speed * delta)
			if is_equal_approx(position.y, target_position.y):
				moving_x = true
				start_moving = false
				$PositionTimer.start()
		$BodySprite.rotation = lerp_angle($BodySprite.rotation, target_angle, delta * 5.0)

func boss_start():
	moving_x = false
	call_count = 0
	update_health_bar()
	position = Vector2(1920/2, 1080/2)
	scale = Vector2(0,0)
	await get_tree().create_timer(2).timeout
	for i in range(2):
		var cannon = cannon_scene.instantiate()
		if i == 0:
			cannon.position = Vector2(215,843)
			cannon.get_node("Rotatable").rotation = deg_to_rad(45)
		if i == 1:
			cannon.position = Vector2(1705,237)
			cannon.get_node("Rotatable").rotation = deg_to_rad(135)
		get_parent().add_child(cannon)
	
	show()
	for i in range(20): 
		scale.x += 0.05
		scale.y += 0.05
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.3).timeout
	active_boss = true
	$AttackTimer.start()
	$PositionTimer.start()

#
func pick_target():
	#var screen_size = get_viewport_rect().size
	start_moving = true
	var min_margin = 200.0
	var x = randf_range(min_margin, 1920 - min_margin)
	var y = randf_range(min_margin, 1080 - min_margin)
	target_position = Vector2(x, y)
	moving_x = true
	#print("boss_pos" + str(target_position))

func boss_move(move):
	$AttackTimer.stop()
	if move == "shrapnel":
		var bullet = bullet_scene.instantiate()
		bullet.bullet_move = "tank_explode"
		bullet.position = $TurretSprite/Marker2D.global_position
		bullet.direction = turret_direction.rotated(deg_to_rad(-90))
		get_parent().add_child(bullet)
	if move == "bomb":
		var angle_step = TAU / 10
		var bomb_distance = randf_range(650,720)
		for i in 10:
			var angle = i * angle_step
			var direction = Vector2.RIGHT.rotated(angle)
			var bomb = bomb_scene.instantiate()
			bomb.position = position
			bomb.direction = direction
			bomb.velocity = bomb_distance
			bomb.add_to_group("enemy_group")
			bomb.bomb_type = "boss"
			get_parent().add_child(bomb)
	if move == "shotgun":
		for i in 3:
			multiple_bullets(3,false)
			await get_tree().create_timer(0.4).timeout
			multiple_bullets(4,false)
			await get_tree().create_timer(0.4).timeout
	if move == "spray":
		for i in 13:
			multiple_bullets(randi_range(1,2),true)
			await get_tree().create_timer(0.2).timeout

"""
	if move == "shotgun":
		for i in 2:
			shotgun_attack(5)
			await get_tree().create_timer(0.5).timeout
			shotgun_attack(4)
			await get_tree().create_timer(0.5).timeout
			"""

func _on_attack_timer_timeout():
	if active_boss == false:
		$AttackTimer.stop()
		return
	var attack_number = move_numbers[randi_range(0, move_numbers.size() - 1)]
	move_numbers = [0,1,2,3]
	move_numbers.erase(attack_number)
	var choose_boss_move = set_moves[attack_number]
	await boss_move(choose_boss_move)
	#await get_tree().create_timer(set_wait[attack_number]).timeout
	$AttackTimer.wait_time = set_wait[attack_number]
	$AttackTimer.start()

func multiple_bullets(bullet_count: int, add_diff: bool):
	var spread_angle = deg_to_rad(12)
	var mid_index = (bullet_count - 1) / 2.0
	var base_angle = turret_direction.angle()
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		bullet.bullet_move = "tank_regular"
		bullet.position = position
		var angle_offset = (i - mid_index) * spread_angle
		if add_diff:
			angle_offset += randf_range(-deg_to_rad(3), deg_to_rad(3))
		bullet.rotation = base_angle + angle_offset - deg_to_rad(90)
		get_parent().add_child(bullet)

#health and end state

func take_damage(amount):
	current_health = max(current_health - amount, 0)
	update_health_bar()

func update_health_bar():
	if current_health <= 0:
		boss_dead("boss")
		call_count += 1
	else:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _on_hp_manager_player_dead():
	if active_boss == true:
		boss_dead("player")
		call_count += 1

func boss_dead(status):
	if call_count >= 2:
		return
	print("boss_end" + status)
	$AttackTimer.stop()
	current_health = 100
	active_boss = false
	hide()
	
	if status == "boss":
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = true
		get_tree().get_first_node_in_group("hp_manager_group").player_dead.emit()
	if status == "player":
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = false
	
	get_tree().get_first_node_in_group("end_screen_group").update_score()
	
	for node in get_tree().get_nodes_in_group("cannon_group"):
		node.queue_free()
	for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
		spawner.in_boss = false
	for enemy in get_tree().get_nodes_in_group("enemy_group"):
		enemy.queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("cannon_ball_group"):
		take_damage(15)

"""
func update_health_bar():
	if current_health <= 0:
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = true
		#boss_current_dead = true
		current_health = 100
		active_boss = false
		#moving = false
		$AttackTimer.stop()
		hide()
		for node in get_tree().get_nodes_in_group("cannon_group"):
			node.queue_free()
		for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
			spawner.in_boss = false
		for enemy in get_tree().get_nodes_in_group("enemy_group"):
			enemy.queue_free()
		get_tree().get_first_node_in_group("hp_manager_group").player_dead.emit()
	else:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _on_hp_manager_player_dead():
	if active_boss == true:
		print("player_died_boss")
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = false
		current_health = 100
		active_boss = false
		#get_tree().get_first_node_in_group("end_screen_group").boss_defeated = true
		get_tree().get_first_node_in_group("hp_manager_group").player_dead.emit()
		#moving = false
		$AttackTimer.stop()
		
		hide()
		for node in get_tree().get_nodes_in_group("cannon_group"):
			node.queue_free()
		for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
			spawner.in_boss = false
		for enemy in get_tree().get_nodes_in_group("enemy_group"):
			enemy.queue_free()
	#elif boss_current_dead == true:
	#	boss_current_dead = false
"""
