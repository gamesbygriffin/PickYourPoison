extends PanelContainer

var set_animation = ["nothing","beanie","propeller", "chef", "cowboy", "party", "top", "crown"]
var set_names = ["Unequip","Beanie","Propeller", "Chef's Hat", "Cowboy Hat", "Party Hat", "Top Hat", "Crown", "idk"]
var set_costs = [0,10, 10, 15, 15, 20, 25, 50,0]

var unlock = false
var hat_index = 0

func _ready():
	unlock = false
	if hat_index == 0:
		$Control/ButtonSprite.animation = "equip"
	else:
		$Control/ButtonSprite.animation = set_animation[hat_index]
	$Control/Sprite.animation = set_animation[hat_index]
	$Control/Label.text = set_names[hat_index]

func _on_button_pressed():
	if Global.cir_money >= set_costs[hat_index] and unlock == false:
		print("bought"+str(set_animation[hat_index]))
		Global.cir_money -= set_costs[hat_index]
		unlock = true
		$Control/ButtonSprite.animation = "equip"
	elif unlock == true:
		print("equip"+str(set_animation[hat_index]))
		for player in get_tree().get_nodes_in_group("player_group"):
			player.hat_number = hat_index
	elif Global.cir_money < set_costs[hat_index]:
		return
