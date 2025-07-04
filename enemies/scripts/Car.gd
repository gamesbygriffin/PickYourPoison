extends Area2D

var speed = 700
var acceleration: int

func _ready():
	$AnimatedSprite2D.animation = str(randi_range(1,3))

func _process(delta):
	if Global.in_game == true:
		position.x -= (speed + acceleration) * delta
		acceleration += 2
