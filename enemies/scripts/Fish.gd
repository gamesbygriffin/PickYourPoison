extends Area2D

var amplitude = 50
var speed = 2.0
var swim_speed = 200
var time = 0.0
var start_y

func _ready():
	$AnimatedSprite2D.animation = str(randi_range(1,3))
	amplitude = randi_range(30,60)
	swim_speed = randi_range(200,350)
	speed = randi_range(2.0,5.0)
	position = Vector2(2000,randf_range(100,980))
	scale.x = -1
	start_y = position.y

func _process(delta):
	if Global.in_game == true:
		position.x -= swim_speed * delta
		time += delta * speed
		position.y = start_y + sin(time) * amplitude
		var distance = position.y
		var scale_factor = 0.9 + (distance/5 * 0.001)
		scale = Vector2(-scale_factor, scale_factor)
