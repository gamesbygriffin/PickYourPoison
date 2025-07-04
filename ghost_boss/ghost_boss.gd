extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var furniture_scene: PackedScene
@export var max_health := 100

@onready var health_bar = $HealthBar

var set_moves = ["ring", "double_ring", "four", "homing", "drift"]
var set_move_time = [2.5,3,3.5,3.5,2.5]
var moving = false
var target_position = Vector2.ZERO
var move_speed = 5.0
var furniture_amount: int
var active_boss
var current_health := max_health
var boss_current_dead

func _ready():
	add_to_group("ghost_boss_group")
	#modulate.a = 0.0
	hide()
	#for i in range(10):
	#	modulate.a += 0.1

func boss_start():
	active_boss = true
	update_health_bar()
	$FurnTimer.start()
	$AnimationPlayer.get_animation("squish").loop = true
	position = Vector2(963,540)
	scale = Vector2(0,0)
	await get_tree().create_timer(2).timeout
	show()
	$AnimationPlayer.play("show")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("squish")
	await get_tree().create_timer(1).timeout
	boss_move("drift")

func take_damage(amount):
	current_health = max(current_health - amount, 0)
	update_health_bar()

func boss_move(move):
	if active_boss == false:
		return
	$Timer.stop()
	if move == "drift":
		target_position = Vector2(randi_range(100,1820), randi_range(100,980))
		moving = true
	elif move == "ring":
		for i in range(30):
			var bullet = bullet_scene.instantiate()
			bullet.bullet_move = "ring"
			bullet.position = position
			bullet.rotation_degrees = 12 * i
			get_parent().add_child(bullet)
	elif move == "double_ring":
		for i in range(18):
			var bullet = bullet_scene.instantiate()
			bullet.bullet_move = "double_ring"
			bullet.position = position
			bullet.rotation_degrees = 20 * i
			get_parent().add_child(bullet)
		await get_tree().create_timer(0.7).timeout
		for i in range(15):
			var bullet = bullet_scene.instantiate()
			bullet.bullet_move = "double_ring"
			bullet.position = position
			bullet.rotation_degrees = 24 * i
			get_parent().add_child(bullet)
	elif move == "four":
		var random_number: int
		for f in range(3):
			random_number = randi_range(6,10)
			for i in range(random_number):
				var bullet = bullet_scene.instantiate()
				bullet.bullet_move = "four"
				bullet.position = position
				bullet.rotation_degrees = (360/random_number) * i
				get_parent().add_child(bullet)
			
			await get_tree().create_timer(0.5).timeout
			
			random_number = randi_range(8,12)
			for i in range(random_number):
				var bullet = bullet_scene.instantiate()
				bullet.bullet_move = "four"
				bullet.position = position
				bullet.rotation_degrees = (360/random_number) * i
				get_parent().add_child(bullet)
			await get_tree().create_timer(0.5).timeout
	elif move == "homing":
		var set_homing = [0,1,2,3,4]
		for i in range(5):
			var bullet = bullet_scene.instantiate()
			var random_homing = set_homing[randi_range(0,4-i)]
			set_homing.erase(random_homing)
			if random_homing == 0:
				bullet.bullet_move = "homing"
			else:
				bullet.bullet_move = "four"
			bullet.position = position
			bullet.rotation_degrees = 72 * i
			get_parent().add_child(bullet)

func _process(delta):
	if moving and active_boss:
		$Area2D/CollisionShape2D.disabled = true
		position = position.lerp(target_position, move_speed * delta)
		if position.distance_to(target_position) < 10:
			moving = false
			$Timer.wait_time = 1
			$Timer.start()
	else:
		$Area2D/CollisionShape2D.disabled = false

func _on_timer_timeout():
	var choose_number = randi_range(0,3)
	var boss_choose_move = str(set_moves[choose_number])
	#var boss_choose_move = "homing"
	boss_move(boss_choose_move)
	await get_tree().create_timer(set_move_time[choose_number]).timeout
	boss_move("drift")

func _on_furn_timer_timeout():
	$FurnTimer.wait_time = randi_range(7,8)
	if furniture_amount <= 1:
		var furn = furniture_scene.instantiate()
		furn.furniture_number = randi_range(1,4)
		get_parent().add_child(furn)

func update_health_bar():
	if current_health <= 0:
		boss_dead("boss")
	else:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _on_hp_manager_player_dead():
	if active_boss == true:
		boss_dead("player")

func boss_dead(status):
	print("boss_end" + status)
	$Timer.stop()
	$FurnTimer.stop()
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
"""
func _on_hp_manager_player_dead():
	if active_boss == true:
		print("player_died_boss")
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = false
		current_health = 100
		active_boss = false
		#get_tree().get_first_node_in_group("end_screen_group").boss_defeated = true
		get_tree().get_first_node_in_group("hp_manager_group").player_dead.emit()
		moving = false
		$Timer.stop()
		$FurnTimer.stop()
		hide()
		for node in get_tree().get_nodes_in_group("furniture_group"):
			node.queue_free()
		for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
			spawner.in_boss = false
		for enemy in get_tree().get_nodes_in_group("enemy_group"):
			enemy.queue_free()
	elif boss_current_dead == true:
	boss_current_dead = false
func update_health_bar():
	if current_health <= 0:
		get_tree().get_first_node_in_group("end_screen_group").boss_defeated = true
		boss_current_dead = true
		current_health = 100
		active_boss = false

		moving = false
		$Timer.stop()
		$FurnTimer.stop()
		hide()
		for node in get_tree().get_nodes_in_group("furniture_group"):
			node.queue_free()
		for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
			spawner.in_boss = false
		for enemy in get_tree().get_nodes_in_group("enemy_group"):
			enemy.queue_free()
		get_tree().get_first_node_in_group("hp_manager_group").player_dead.emit()
	else:
		health_bar.max_value = max_health
		health_bar.value = current_health
"""
