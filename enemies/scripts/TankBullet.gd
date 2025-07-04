extends Area2D

var speed = 300
var acceleration = 0

func _ready():
	add_to_group("enemy_group")

func _process(delta):
	if Global.in_game == true:
		position.x -= (speed + acceleration) * delta
		acceleration += 3

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
