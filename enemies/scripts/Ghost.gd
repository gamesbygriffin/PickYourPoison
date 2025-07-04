extends Area2D

var amplitude = 100
var speed = 2.0
var max_speed: int
var time = 0.0
var start_y

func _ready():
	max_speed = randi_range(100,150)
	position = Vector2(2000,randf_range(100,980))
	start_y = position.y

func _process(delta):
	if Global.in_game == true:
		position.x -= max_speed * delta
		
		time += delta * speed
		position.y = start_y + sin(time) * amplitude
		
		var distance = position.y
		var scale_factor = 0.9 + (distance/5 * 0.001)
		scale = Vector2(-scale_factor, scale_factor)
