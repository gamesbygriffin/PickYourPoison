extends Area2D

var roll_speed : float = 200
var rotation_speed : float = -4

var fall_speed : float = 300
var target_position
var acceleration = 0

var amplitude = 100
var speed = 1.0
var mult_speed = 100
var time = 0.0
var start_y

var money_type

func _ready():
	add_to_group("spawn_group")
	add_to_group("money_group")
	$Sprite.animation = str(money_type)
	if money_type == "fall":
		position.x = target_position.x
		position.y = -100
	if money_type == "mult":
		position = Vector2(2000,randf_range(100,980))
		start_y = position.y

func _process(delta):
	if Global.in_game == true:
		if money_type == "roll":
			position.x -= roll_speed * delta
			rotation += rotation_speed * delta
		elif money_type == "fall":
			if position.y < target_position.y:
				position.y += (acceleration + fall_speed) /2 * delta
				acceleration += 25
				if position.y > target_position.y:
					position.y = target_position.y
					$Timer.start()
		elif money_type == "mult":
			position.x -= mult_speed * delta
			time += delta * speed
			position.y = start_y + sin(time) * amplitude
			var distance = position.y
			var scale_factor = 0.9 + (distance/5 * 0.001)
			scale = Vector2(-scale_factor, scale_factor)

func _on_body_entered(body):
	if body.is_in_group("player_group"):
		queue_free()

func _on_timer_timeout():
	for i in range(100):
		scale.x -= 0.01
		scale.y -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
