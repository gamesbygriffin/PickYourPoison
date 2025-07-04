extends Area2D

var radius = 100
var speed = 2.0
var angle = 0.0
var center_position
var move_speed = 300

func _ready():
	center_position = Vector2(2000,randf_range(100,980))

func _process(delta):
	if Global.in_game == true:
		angle += speed * delta
		center_position.x -= move_speed * delta
		position.x = center_position.x + cos(angle) * radius
		position.y = center_position.y + sin(angle) * radius
		rotation += 0.005
