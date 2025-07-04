extends Node

@export var fish_scene: PackedScene
@export var icicle_scene: PackedScene
@export var arrow_scene: PackedScene
@export var insect_scene: PackedScene
@export var anvil_scene: PackedScene
@export var cart_scene: PackedScene
@export var bomb_scene: PackedScene
@export var car_scene: PackedScene
@export var tank_scene: PackedScene
@export var drone_scene: PackedScene
@export var ufo_scene: PackedScene
@export var spike_scene: PackedScene
@export var plane_scene: PackedScene
@export var spikeblock_scene: PackedScene
@export var ghost_scene: PackedScene

var set_enemies_unlocked = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false]
var set_enemies = ["insect","anvil", "arrow", "icicle","bomb","cart", "car", "drone", "fire", "fish", "plane", "spike", "spikeblock","tank", "ufo", "ghost"]
var set_wait_times = [3,6,4,2,3,3.5,6,3,null,null,5.5,2,6,5.5,4.5,4]

var enemy_number
var player_nodes
var player_position
var in_boss = false
#Ufo, Plane, Spike Block, Fire, Spike

func _ready():
	add_to_group("enemy_spawner_group")
	#create_enemy_timer(6)
	#create_enemy_timer(1)
	#create_enemy_timer(2)
	#create_enemy_timer(3)
	#create_enemy_timer(5)

func _on_hud_start_game():
	in_boss = false

func _on_hp_manager_player_dead():
	for timer in get_tree().get_nodes_in_group("spawn_timer_group"):
		timer.queue_free()
	for enemy in get_tree().get_nodes_in_group("enemy_group"):
		enemy.queue_free()
	for enemy in get_tree().get_nodes_in_group("spawn_group"):
		enemy.queue_free()

func _process(delta):
	player_nodes = get_tree().get_nodes_in_group("player_group")
	if player_nodes.size() > 0:
		player_position = Vector2(player_nodes[0].position.x,player_nodes[0].position.y) 
	if Global.in_game == true:
		pass
		#for timer in get_tree().get_nodes_in_group("spawn_timer_group"):
		#	
	elif Global.in_game == false:
		pass
		#for imer in get_tree().get_nodes_in_group("spawn_timer_group"):
		#	imer.stop()

func timers_stop():
	#if Global.in_game == false:
	for timer in get_tree().get_nodes_in_group("spawn_timer_group"):
		timer.stop()
		print("timer_stop")

func timers_start():
	if Global.in_game == true:
		for timer in get_tree().get_nodes_in_group("spawn_timer_group"):
			timer.start()

func unlock_enemy(number):
	await wait_in_game()
	set_enemies_unlocked[number] = true
	#get_tree().create_timer(0.05).timeout 
	create_enemy_timer(number)

func wait_in_game():
	while Global.in_game == false:
		await get_tree().create_timer(0).timeout

func create_enemy_timer(val):
	var my_timer = Timer.new()
	my_timer.wait_time = set_wait_times[val]
	my_timer.one_shot = false
	my_timer.name = str(set_enemies[val])
	my_timer.add_to_group("spawn_timer_group")
	add_child(my_timer)
	my_timer.timeout.connect(func(): spawn_enemy(val,my_timer))
	#my_timer.timeout.connect(func(): call(set_enemies[val] + "_timer_timeout"))
	my_timer.start()
	print(str(get_tree().get_nodes_in_group("spawn_timer_group")))

func spawn_enemy(number,timer):
	timer.wait_time = timer.wait_time * randf_range(0.95,1.05)
	#print(timer.wait_time)
	if Global.in_game == false or in_boss == true:
		if Global.player_hp <= 0:
			for enemy in get_tree().get_nodes_in_group("enemy_group"):
				enemy.queue_free()
		return
	elif Global.in_game == true:
		if number == 0:
			for i in range(3,7):
				var insect = insect_scene.instantiate()
				insect.add_to_group("enemy_group")
				get_parent().add_child(insect)
		elif number == 1:
			var anvil = anvil_scene.instantiate()
			anvil.add_to_group("enemy_group")
			anvil.target_position = Vector2(player_position.x + randi_range(-10,10), player_position.y + randi_range(-10,10))
			get_parent().add_child(anvil)
		elif number == 2:
			var overall_target = Vector2(randi_range(200,1720),randi_range(200,880))
			for i in range(10,15):
				await get_tree().create_timer(randi_range(0,0.05)).timeout
				var arrow = arrow_scene.instantiate()
				arrow.add_to_group("enemy_group")
				arrow.target_position = Vector2(overall_target.x + randi_range(-70,70),overall_target.y + randi_range(-70,70))
				get_parent().add_child(arrow)
		elif number == 3:
			for i in range(1,3):
				var icicle = icicle_scene.instantiate()
				icicle.add_to_group("enemy_group")
				get_parent().add_child(icicle)
		elif number == 4:
			var bomb = bomb_scene.instantiate()
			bomb.add_to_group("enemy_group")
			bomb.bomb_type = "level"
			get_parent().add_child(bomb)
		elif number == 5:
			var cart = cart_scene.instantiate()
			cart.add_to_group("enemy_group")
			get_parent().add_child(cart)
		elif number == 6:
			var car_current_pos = Vector2(2000,randf_range(100,980))
			for i in range(randi_range(5,10)):
				var car = car_scene.instantiate()
				car.position = car_current_pos
				car.add_to_group("enemy_group")
				get_parent().add_child(car)
				await get_tree().create_timer(0.4).timeout
		elif number == 7:
			var drone = drone_scene.instantiate()
			drone.add_to_group("enemy_group")
			get_parent().add_child(drone)
		elif number == 10:
			var plane = plane_scene.instantiate()
			plane.add_to_group("enemy_group")
			get_parent().add_child(plane)
		elif number == 11:
			var spike = spike_scene.instantiate()
			spike.position = Vector2(player_position.x - randi_range(50, 200), player_position.y - randi_range(50, 200))
			spike.add_to_group("enemy_group")
			get_parent().add_child(spike)
		elif number == 12:
			var spikeblock = spikeblock_scene.instantiate()
			spikeblock.add_to_group("enemy_group")
			get_parent().add_child(spikeblock)
		elif number == 13:
			var tank = tank_scene.instantiate()
			tank.position = Vector2(2000,randf_range(100,980))
			tank.add_to_group("enemy_group")
			get_parent().add_child(tank)
		elif number == 14:
			var ufo = ufo_scene.instantiate()
			ufo.add_to_group("enemy_group")
			get_parent().add_child(ufo)
		elif number == 15:
			for i in range(randi_range(1,3)):
				var ghost = ghost_scene.instantiate()
				ghost.add_to_group("enemy_group")
				get_parent().add_child(ghost)

func _on_level_manager_boss_start():
	in_boss = true
	for node in get_tree().get_nodes_in_group("enemy_group"):
		node.queue_free()

"""
func icicle_timer_timeout():
	for i in range(1,3):
		var icicle = icicle_scene.instantiate()
		icicle.add_to_group("enemy_group")
		get_parent().add_child(icicle)

func fish_timer_timeout():
	for i in range(1,2):
		var fish = fish_scene.instantiate()
		fish.add_to_group("enemy_group")
		get_parent().add_child(fish)

func insect_timer_timeout():
	for i in range(3,7):
		var insect = insect_scene.instantiate()
		insect.add_to_group("enemy_group")
		get_parent().add_child(insect)

func cart_timer_timeout():
	var cart = cart_scene.instantiate()
	cart.add_to_group("enemy_group")
	get_parent().add_child(cart)

func car_timer_timeout():
	var car_current_pos = Vector2(2000,randf_range(100,980))
	for i in range(randi_range(5,10)):
		var car = car_scene.instantiate()
		car.position = car_current_pos
		car.add_to_group("enemy_group")
		get_parent().add_child(car)
		await get_tree().create_timer(0.4).timeout

func bomb_timer_timeout():
	var bomb = bomb_scene.instantiate()
	bomb.add_to_group("enemy_group")
	get_parent().add_child(bomb)

func anvil_timer_timeout():
	var anvil = anvil_scene.instantiate()
	anvil.add_to_group("enemy_group")
	anvil.target_position = Vector2(player_position.x + randi_range(-10,10), player_position.y + randi_range(-10,10))
	get_parent().add_child(anvil)

func arrow_timer_timeout(): 
	var overall_target = Vector2(randi_range(200,1720),randi_range(200,880))

	for i in range(10,15):
		await get_tree().create_timer(randi_range(0,0.05)).timeout
		var arrow = arrow_scene.instantiate()
		arrow.add_to_group("enemy_group")
		arrow.target_position = Vector2(overall_target.x + randi_range(-70,70),overall_target.y + randi_range(-70,70))
		get_parent().add_child(arrow)
"""

