extends Area2D

var move_x = 0
var move_y = 0

func _ready():
	$Timer.start()
	position = Vector2(2000,randf_range(320,760))
	move_x = 200

func _process(delta):
	if Global.in_game == true:
		position.x -= move_x * delta
		position.y += move_y * delta

func _on_timer_timeout():
	if Global.in_game == true:
		$Timer.stop()
		if move_x > 0:
			move_x = 0
			var random_num = randi_range(1,2)
			if random_num == 1:
				move_y = 300
			else:
				move_y = -300
			$Timer.wait_time = randf_range(0.5, 1.5)
		elif move_x == 0:
			move_y = 0
			move_x = 300
			$Timer.wait_time = randf_range(2,3)
		$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
