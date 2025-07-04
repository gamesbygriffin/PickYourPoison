extends CanvasLayer
signal start_game

var tutorial_show
var scale_direction = "up"
var scale_min = Vector2(0.2, 0.2)
var scale_max = Vector2(0.21, 0.21)
var speed = 1.0

func _process(delta):
	var t = (sin(Time.get_ticks_msec() / 1000.0 * speed) + 1.0) / 2.0
	$Sprite2D.scale = scale_min.lerp(scale_max, t)
	if Global.in_game == false and visible == true:
		for enemy in get_tree().get_nodes_in_group("enemy_group"):
			enemy.queue_free()
	if tutorial_show == true:
		$TutorialButton.show()
	else:
		$TutorialButton.hide()

func _ready():
	$TutorialHUD.hide()
	tutorial_show = false
	Global.in_game = false
	#$Timer.start()

func _on_button_pressed():
	if tutorial_show == false:
		$TutorialHUD.start_turtorial()
		#tutorial_show = true
		return
	hide()
	start_game.emit()
	Global.level_number = 0
	Global.tri_money = 0
	Global.in_game = true

func _on_timer_timeout():
	$Timer.stop()
	if scale_direction == "up":
		for i in range(10):
			$Sprite2D.scale.x += 0.001
			$Sprite2D.scale.y += 0.001
			await get_tree().create_timer(0.01).timeout
		scale_direction = "down"
	elif scale_direction == "down":
		for i in range(10):
			$Sprite2D.scale.x -= 0.001
			$Sprite2D.scale.y -= 0.001
			await get_tree().create_timer(0.01).timeout
		scale_direction = "up"
	$Timer.start()


func _on_hp_manager_player_dead():
	show()

func _on_tutorial_button_pressed():
	$TutorialHUD.start_turtorial()
