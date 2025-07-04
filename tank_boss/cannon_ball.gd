extends Area2D

var direction
var velocity = Vector2.ZERO
var acceleration: float = 3000.0
var max_speed: float = 1000.0
var moving = true

func _process(delta):
	if moving == true:
		velocity += direction * acceleration * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
		position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("tank_boss_group"):
		moving = false
		for i in range(30):
			scale += Vector2(0.02, 0.02)
			await get_tree().create_timer(0.01).timeout
		queue_free()
