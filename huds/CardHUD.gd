extends CanvasLayer

@export var enemy_card_scene: PackedScene
@export var upgrade_card_scene: PackedScene

var set_cards = []
var set_current_cards = []
 
var set_upgrade_cards = []

func _ready():
	$Button.pivot_offset = $Button.size / 2
	$Button.position = Vector2((1920 - $Button.size.x) / 2, 850)
	add_to_group("card_hud_group")

func spawn_cards(type):
	Global.in_game = false
	$Timer.stop()
	if type == "enemy":
		set_current_cards = set_cards.duplicate()
		#print("set_current" + str(set_current_cards), " set_cards" + str(set_cards))
		#1
		var enemy_card = enemy_card_scene.instantiate()
		enemy_card.position = Vector2(93, 259)
		enemy_card.rotation = -0.17
		var card_number = set_current_cards[randi_range(0,set_current_cards.size()-1)]
		enemy_card.card_number = card_number
		enemy_card.add_to_group("choose_card_group")
		set_current_cards.erase(card_number)
		add_child(enemy_card)
		#2
		enemy_card = enemy_card_scene.instantiate()
		enemy_card.position = Vector2(736.5, 175)
		card_number = set_current_cards[randi_range(0,set_current_cards.size()-1)]
		enemy_card.card_number = card_number
		enemy_card.add_to_group("choose_card_group")
		set_current_cards.erase(card_number)
		add_child(enemy_card)
		#3
		enemy_card = enemy_card_scene.instantiate()
		enemy_card.position = Vector2(1374, 190)
		enemy_card.rotation = 0.17
		card_number = set_current_cards[randi_range(0,set_current_cards.size()-1)]
		enemy_card.card_number = card_number
		enemy_card.add_to_group("choose_card_group")
		set_current_cards.erase(card_number)
		add_child(enemy_card)
	elif Global.level_number == 1:
		Global.in_game = true
		for timer in get_tree().get_nodes_in_group("timer_hud_group"):
			timer.start()
	elif type == "upgrade":
		button_visibility("show")
		set_upgrade_cards = [0,1,2,3,4,5,6,7]
		#1
		var upgrade_card = upgrade_card_scene.instantiate()
		upgrade_card.position = Vector2(93, 259)
		upgrade_card.rotation = -0.17
		var card_number = set_upgrade_cards[randi_range(0,set_upgrade_cards.size()-1)]
		upgrade_card.card_number = card_number
		upgrade_card.add_to_group("choose_upgrade_group")
		set_upgrade_cards.erase(card_number)
		add_child(upgrade_card)
		#2
		upgrade_card = upgrade_card_scene.instantiate()
		upgrade_card.position = Vector2(736.5, 175)
		card_number = set_upgrade_cards[randi_range(0,set_upgrade_cards.size()-1)]
		upgrade_card.card_number = card_number
		upgrade_card.add_to_group("choose_upgrade_group")
		set_upgrade_cards.erase(card_number)
		add_child(upgrade_card)
		#3
		upgrade_card = upgrade_card_scene.instantiate()
		upgrade_card.position = Vector2(1374, 190)
		upgrade_card.rotation = 0.17
		card_number = set_upgrade_cards[randi_range(0,set_upgrade_cards.size()-1)]
		upgrade_card.card_number = card_number
		upgrade_card.add_to_group("choose_upgrade_group")
		set_upgrade_cards.erase(card_number)
		add_child(upgrade_card)

func button_visibility(vis):
	if vis == "show":
		$Button.show()
		$Button.disabled = false
		$Button.scale = Vector2.ZERO
		for i in range(20): 
			$Button.scale.x += 0.05
			$Button.scale.y += 0.05
			await get_tree().create_timer(0.01).timeout
	else:
		$Button.disabled = true
		$Button.scale = Vector2.ONE
		for i in range(20): 
			$Button.scale.x -= 0.05
			$Button.scale.y -= 0.05
			await get_tree().create_timer(0.01).timeout
		$Button.hide()

func _on_timer_timeout():
	var manager = get_tree().get_nodes_in_group("level_manager_group")
	for node in manager:
		#rint("next_levl")
		node.next_level()
	if Global.level_number == 6:
		$Timer.stop()
		return
	spawn_cards("enemy")
	$Timer.wait_time *= 1.4

func erase_set(val):
	set_cards.erase(val)

func _on_level_manager_boss_start():
	$Timer.stop()

func _on_hud_start_game():
	$Button.hide()
	button_visibility("hide")
	await get_tree().create_timer(1).timeout
	set_cards = [0,1,2,4,5,6,7,10,12,13,14,15]
	#set_cards = [15]
	#,6,7,8,9,10,11,12
	$Timer.wait_time = 20
	#$Timer.wait_time = 3
	_on_timer_timeout()
	$Timer.add_to_group("timer_hud_group")


func _on_hp_manager_player_dead():
	$Timer.stop()

func _on_button_pressed():
	Global.in_game = true
	for card_nodes in get_tree().get_nodes_in_group("choose_upgrade_group"):
		card_nodes.delete_card()
	for timer in get_tree().get_nodes_in_group("timer_hud_group"):
		timer.start()
	button_visibility("hide")
