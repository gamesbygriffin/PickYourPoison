extends PanelContainer

var set_names = [
"Speed Rush l", "Speed Rush ll", "Health Boost l", "Health Boost ll", "Money Bonus l", "Money Bonus ll", "Money Bonus lll", "Swift Dash l"
]
var set_animations = [
"speed1","speed2", "health1", "health2", "money1","money2", "money3",  "dash1"
]
var set_descriptions = [
"+ 1 speed level","+ 2 speed levels","+ 1 hp","+ 2 hp","Increase coin spawns 1 level","Increase coin spawns 2 levels","Increase coin spawns 3 levels","Increase dash range and speed",
]

var set_costs = [
{"max": 8, "min": 10},
{"max": 18, "min": 20},
{"max": 18, "min": 20},
{"max": 26, "min": 28},
{"max": 7, "min": 9},
{"max": 10, "min": 12},
{"max": 14, "min": 16},
{"max": 15, "min": 17}
]
#randi_range(set_costs[card_number][min],set_costs[card_number][max])

var card_number = 0
var starting_position
var increase_scale_x
var increase_scale_y
var entered = false
var cost

var player_nodes
var money_spawner_nodes

func _ready():
	player_nodes = get_tree().get_first_node_in_group("player_group")
	money_spawner_nodes = get_tree().get_first_node_in_group("money_spawner_group")
	cost = randi_range(set_costs[card_number]["min"],set_costs[card_number]["max"]) + Global.level_number + 1
	var width
	var height
	var shape = $Area2D/CollisionShape2D.shape
	if shape is RectangleShape2D:
		width = shape.extents.x * 2
		height = shape.extents.y * 2
	#print(position)
	starting_position = position
	$Control/Name.text = set_names[card_number]
	$Control/Description.text = set_descriptions[card_number]
	$Control/Sprite.animation = set_animations[card_number]
	$Control/BuyButton.text = "Buy for " + str(cost)
	increase_scale_x = (width * 0.1) /2
	increase_scale_y = (height * 0.1) /2
	scale = Vector2(0,0)

func _process(delta):
	if scale != Vector2(1, 1) and entered == false:
		var new_scale = lerp(scale.x, 1.0, delta * 5.0)
		scale = Vector2(new_scale, new_scale)

func _on_area_2d_mouse_entered():
	entered = true
	scale = Vector2(1.1,1.1)
	position = Vector2(starting_position.x - increase_scale_x, starting_position.y - increase_scale_y)

func _on_area_2d_mouse_exited():
	entered = false
	scale = Vector2(1,1)
	position = starting_position

func delete_card():
	$Control/BuyButton.disabled = true
	for i in range(100):
		modulate.a -= 0.01
		$Control/Sprite.modulate.a -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()

func _on_buy_button_pressed():
	if Global.tri_money < cost:
		$Control/BuyButton.text = "Not Enough"
		return
		$Control/BuyButton.disabled = true
	get_parent().button_visibility("hide")
	Global.tri_money -= cost
	Global.in_game = true
	#"Speed Rush l", "Speed Rush ll", "Health Boost l", "Health Boost ll", "Money Bonus l", "Money Bonus ll", "Money Bonus lll", "Swift Dash l"
	if card_number == 0:
		player_nodes.max_speed += 100
	if card_number == 1:
		player_nodes.max_speed += 165
	if card_number == 2:
		Global.player_hp += 1
		get_tree().get_first_node_in_group("end_screen_group").hp_tracker -= 1
	if card_number == 3:
		get_tree().get_first_node_in_group("end_screen_group").hp_tracker -= 2
		Global.player_hp += 2
	if card_number == 4:
		money_spawner_nodes.timer_decrease += 0.5
		money_spawner_nodes.update_timer()
	if card_number == 5:
		money_spawner_nodes.timer_decrease += 1.0
		money_spawner_nodes.update_timer()
	if card_number == 6:
		money_spawner_nodes.timer_decrease += 1.5
		money_spawner_nodes.update_timer()
	if card_number == 7:
		player_nodes.dash_speed += 400
		player_nodes.dash_duration += 0.05
	for card_nodes in get_tree().get_nodes_in_group("choose_upgrade_group"):
		card_nodes.delete_card()
	for timer in get_tree().get_nodes_in_group("timer_hud_group"):
		timer.start()
	#get_parent().erase_set(card_number)
	#for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
	#	spawner.timers_start()
