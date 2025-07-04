extends Node

@export var coin_scene: PackedScene

var timer_decrease = 0

func _ready():
	add_to_group("money_spawner_group")

func _on_hud_start_game():
	$Timer.wait_time = 6.5
	$Timer.start()

func _on_hp_manager_player_dead():
	$Timer.stop()

func update_timer():
	$Timer.wait_time -= timer_decrease
	print("money_timer" + str($Timer.wait_time))

func _on_timer_timeout():
	if Global.in_game == true and Global.level_number !=6:
		var coin_type = randi_range(0,10)
		if coin_type == 0:
			var coin = coin_scene.instantiate()
			coin.position = Vector2(2000,randi_range(20,1060))
			coin.money_type = "mult"
			get_parent().add_child(coin)
		elif coin_type in range(1,2):
			var overall_target = Vector2(randi_range(20,1900), randi_range(20, 1060))
			for i in range(randi_range(3,5)):
				await get_tree().create_timer(randi_range(0,0.05)).timeout
				var coin = coin_scene.instantiate()
				coin.money_type = "fall"
				coin.target_position = Vector2(overall_target.x + randi_range(-70,70),overall_target.y + randi_range(-70,70))
				get_parent().add_child(coin)
		elif coin_type in range(3,5):
			var coin = coin_scene.instantiate()
			coin.position = Vector2(2000,randi_range(20,1060))
			coin.money_type = "roll"
			get_parent().add_child(coin)
		elif coin_type in range(6,10):
			var coin = coin_scene.instantiate()
			coin.target_position = Vector2(randi_range(20,1900), randi_range(20, 1060))
			coin.money_type = "fall"
			get_parent().add_child(coin)
