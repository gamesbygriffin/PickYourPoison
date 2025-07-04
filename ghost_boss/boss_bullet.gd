extends Area2D

@export var speed : float = 250
@export var rotation_speed : float = 3


var bullet_move: String #general typing
var secondary_move: String #specific typing
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var moving = false

@onready var target = get_tree().get_first_node_in_group("player_group")
var homing_strength: float = 1.5

func _ready():
	add_to_group("enemy_group")
	if bullet_move == "tank_explode" or bullet_move == "tank_regular":
		$TankCollisionShape.disabled = false
	else:
		$GhostCollisionShape.disabled = false
	
	if bullet_move != "tank_expslode" and bullet_move != "tank_regular":
		if bullet_move != "homing":
			var homing_chance = randi_range(0,40)
			if homing_chance == 0:
				bullet_move = "homing"
	
	#Ghost Boss
	if bullet_move != "tank_explode":
		direction = Vector2(cos(rotation), sin(rotation))
	
	if bullet_move == "ring":
		speed = 100
		$AnimatedSprite2D.animation = "1"
		position += direction * 200
		
		await scale_in(20,0.5)
	
	if bullet_move == "double_ring":
		speed = 150
		$AnimatedSprite2D.animation = "1"
		position += direction * 130
		
		await scale_in(20,0.4)
	
	if bullet_move == "four":
		speed = 400
		$AnimatedSprite2D.animation = "1"
		position += direction * 130
		
		await scale_in(20,0.4)
	
	if bullet_move == "homing":
		add_to_group("homing_group")
		$AnimatedSprite2D.animation = "3"
		speed = 300
		position += direction * 130
		await scale_in(20,0.3)
		
		$Timer.wait_time = 4.0
		$Timer.start()
	
	#Tank Boss
	if bullet_move == "tank_explode":
		$AnimatedSprite2D.animation = "5"
		speed = 500
		rotation_speed = 0.0
		rotation = direction.angle()
		
		$Timer.wait_time = 1.5
		$Timer.start()
		
		scale = Vector2(1,1)

	if bullet_move == "tank_regular":
		$AnimatedSprite2D.animation = "4"
		
		rotation_speed = 0.0
		if secondary_move != "shrap":
			position += direction * 120
			speed = 550
		if secondary_move == "shrap":
			#$Timer.wait_time = 2.0
			#$Timer.start()
			speed = 350
		
		scale = Vector2(1,1)
	show()
	if bullet_move != "homing":
		moving = true

func _process(delta):
	if moving == true:
		position += direction * speed * delta
	rotation += rotation_speed * delta
	if bullet_move == "homing":
		var target_pos = target.global_position
		global_position = global_position.lerp(target_pos, homing_strength * delta)
		look_at(target.global_position)
		rotation -= deg_to_rad(90)
	if bullet_move == "torwards_boss":
		position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if bullet_move == "tank_explode":
		_on_timer_timeout()
	queue_free()

func _on_timer_timeout():
	if bullet_move == "tank_explode":
		hide()
		for i in 15:
			var shrap_instance = self.duplicate()
			shrap_instance.bullet_move = "tank_regular"
			shrap_instance.secondary_move = "shrap"
			shrap_instance.position = position
			shrap_instance.rotation_degrees = 24 * i + deg_to_rad(90)
			get_parent().add_child(shrap_instance)
		queue_free()
	for i in range(20):
		scale.x -= 1.0/20
		scale.y -= 1.0/20
		await get_tree().create_timer(0.01).timeout
	queue_free()

func scale_in(num,wait):
	scale = Vector2(0,0)
	show()
	for i in range(num):
		scale.x += 1.0/num
		scale.y += 1.0/num
		await get_tree().create_timer(0.01).timeout
	scale = Vector2(1,1)
	await get_tree().create_timer(wait).timeout

func _on_area_entered(area):
	if area.is_in_group("homing_group") and is_in_group("homing_group"):
		_on_timer_timeout()
		
	if area.is_in_group("bat_group"):
		#bullet_move = "torwards_boss"
		#var direction = (area.global_position - global_position).normalized()
		#velocity = direction * speed
		if is_in_group("homing_group"):
			var boss_nodes = get_tree().get_nodes_in_group("ghost_boss_group")
			if boss_nodes.size() > 0:
				target = boss_nodes[0]
		else:
			pass
			#_on_timer_timeout()
			#moving = false
