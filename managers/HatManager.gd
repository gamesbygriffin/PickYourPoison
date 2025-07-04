extends Node2D

var set_hats = ["Nothing","Beanie","Propeller", "Chef", "Cowboy", "Party", "Top", "Crown"]
#var hat_number

func set_hat(number: int):
	for i in range(set_hats.size()):
		var hat = get_node_or_null(set_hats[i])
		if hat:
			hat.visible = (i == number)
