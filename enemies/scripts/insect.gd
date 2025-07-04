extends Area2D

var speed: int
var acceleration: int

func _ready():
	position = Vector2(2000,randf_range(100,980))
	$AnimatedSprite2D.animation = str(randi_range(1,4))
	speed = randi_range(150,225)

func _process(delta):
	if Global.in_game == true:
		position.x -= speed * delta
		if speed >= 125:
			speed += randi_range(-5,5)
		else:
			speed += randi_range(4,7)
