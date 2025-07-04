extends Area2D

var velocity = 0
var acceleration = -1000
var max_speed = -4000

func _ready():
	position = Vector2(2000,randf_range(320,760))

func _process(delta):
	if Global.in_game == true:
		velocity += acceleration * delta
		velocity = max(velocity, max_speed)
		position.x += velocity * delta

