extends Area2D

@export var speed = 400

var target_position
var acceleration = 0

func _ready():
	position.x = target_position.x
	position.y = -100

func _process(delta):
	if Global.in_game == true:
		if position.y < target_position.y:
			position.y += (acceleration + speed) /2 * delta
			acceleration += 25
			#var distance = position.y
			#var scale_factor = 1 + (distance/3 * 0.001)
			#scale = Vector2(scale_factor, scale_factor)
			if position.y > target_position.y:
				position.y = target_position.y
				$Timer.start()


func _on_timer_timeout():
	for i in range(100):
		scale.x -= 0.01
		scale.y -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
