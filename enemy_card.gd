extends PanelContainer

var set_names = [
"Insect Attack", "Falling Anvils", "Raining Arrows", "Icicles",
"Bombs", "Rogue Cart", "Traffic Jam", "Drones",
"Fire Traps", "School of Fish", "Planes", 
"Spike Traps", "Spikey Blocks","Tank Attack",
 "Ufo Invasion", "Fraid o' Ghost"
]
var set_animations = [
"insect","anvil", "arrow", "icicle", "bomb","cart", "car", 
"drone", "fire", "fish", 
"plane", "spike", "spikeblock","tank", 
"ufo", "ghost"
]
var set_descriptions = [
"Idk waht to sau here :P",
"Look up and try not to get squashed!",
"I don't think umbrellas are gonna work.",
"Its like rain except deadly.",
"BOO0000000000000000OOM!!!",
"Runaway Shopping Cart",
"Watch out people are trying to get to work.",
"Just here to spy on the neigborhood.",
"Watch your feet or you might not have them.",
"Ugh I don't want to go to school :(",
"Never flying Spirit Airlines again.",
"Like sleeping on a bed of nails.",
"You might become a pancake.",
"...",
"Alien invasion try not to get abducted.",
"SPoOkY sCaRy gHoSts"
]

var set_rewards = [
{"name": "+2tri","type": "tri", "amount": 2},
{"name": "+2cir","type": "cir", "amount": 2},

{"name": "+5tri","type": "tri", "amount": 5},
{"name": "+7tri","type": "tri", "amount": 7},
{"name": "x1.5tri","type": "tri", "amount": 1.5},

{"name": "+5cir","type": "cir", "amount": 5},
{"name": "x2tri","type": "tri", "amount": 2},
{"name": "+10tri","type": "tri", "amount": 10},
]

var card_number = 0
var starting_position
var increase_scale_x
var increase_scale_y
var entered = false

var difficulty: int
var reward_name: String
var reward_number

func _ready():
	if card_number in [0,2,3,4,11,12]:
		difficulty = 1
		reward_number = randi_range(0,1)
		reward_name = set_rewards[reward_number]["name"]
	if card_number in [6,7,13,10,5]:
		reward_number = randi_range(2,4)
		difficulty = 2
		reward_name = set_rewards[reward_number]["name"]
	if card_number in [1,14,15,10]:
		reward_number = randi_range(5,7)
		difficulty = 3
		reward_name = set_rewards[reward_number]["name"]
	
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
	$Reward/RewardSprite.animation = str(reward_name)
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

func _on_unlock_button_pressed():
	$Control/UnlockButton.disabled = true
	get_tree().get_first_node_in_group("end_screen_group").dificulty_tracker += difficulty
	#print("reward "+str(reward_name))
	if set_rewards[reward_number]["type"] == "tri":
		if reward_name == "x2tri" or reward_name == "x1.5tri":
			Global.tri_money *= set_rewards[reward_number]["amount"]
			get_tree().get_first_node_in_group("end_screen_group").money_tracker *= set_rewards[reward_number]["amount"]
		else:
			Global.tri_money += set_rewards[reward_number]["amount"]
			get_tree().get_first_node_in_group("end_screen_group").money_tracker += set_rewards[reward_number]["amount"]
	if set_rewards[reward_number]["type"] == "cir":
			Global.cir_money += set_rewards[reward_number]["amount"]
	#Global.in_game = true
	for enemey_spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
		enemey_spawner.unlock_enemy(card_number)
	for card_nodes in get_tree().get_nodes_in_group("choose_card_group"):
		card_nodes.delete_card()
	#for timer in get_tree().get_nodes_in_group("timer_hud_group"):
	#	timer.start()
	get_parent().erase_set(card_number)
	get_parent().spawn_cards("upgrade")
	#for spawner in get_tree().get_nodes_in_group("enemy_spawner_group"):
	#	spawner.timers_start()

func delete_card():
	$Control/UnlockButton.disabled = true
	for i in range(100):
		modulate.a -= 0.01
		$Control/Sprite.modulate.a -= 0.01
		await get_tree().create_timer(0.00001).timeout
	queue_free()
