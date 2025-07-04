extends Area2D



func _ready():
	$AnimatedSprite2D.animation = "1"
	#position = Vector2(randf_range(100,1820),randf_range(100,980))
	$Timer.start()

func _on_body_entered(body):
	if body.is_in_group("player_group"):
		$SpikeTimer.start()

func _on_timer_timeout():
	if Global.in_game == true:
		print("spike")
		$AnimatedSprite2D.animation = "2"
		$SpikeTimer.stop()
		await get_tree().create_timer(1).timeout
		$AnimatedSprite2D.animation = "1"

func _on_free_timeout():
	for i in range(100):
		scale.x -= 0.01
		scale.y -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
