extends Area2D

func _ready():
	$AnimatedSprite2D.animation = str(randi_range(1,4))
	$Timer.start()

func _on_timer_timeout():
	for i in range(100):
		modulate.a -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
