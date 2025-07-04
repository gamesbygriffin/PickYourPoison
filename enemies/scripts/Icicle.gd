extends Area2D

@export var speed = 100

var target_position
var acceleration = 0
var ground_animation = ""

func _ready():
	$AnimatedSprite2D.animation = str(randi_range(1,3))
	target_position = Vector2(randi_range(0,1920),randi_range(200,1080))
	position.x = target_position.x
	position.y = -100
	ground_animation = "ground" + str(randi_range(1,3))

func _process(delta):
	if Global.in_game == true:
		if position.y < target_position.y:
			position.y += (acceleration + speed) /2 * delta
			acceleration += 7
			var distance = position.y
			var scale_factor = 1 + (distance/2 * 0.001)
			scale = Vector2(scale_factor, scale_factor)
			if position.y > target_position.y:
				$AnimatedSprite2D.animation = str(ground_animation)
				position.y = target_position.y
				$Timer.start()


func _on_timer_timeout():
	for i in range(100):
		scale.x -= 0.01
		scale.y -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
