extends Node

signal boss_start

func _ready():
	add_to_group("level_manager_group")
	Global.level_number = 0

func next_level():
	Global.level_number += 1
	if Global.level_number >= 6:
		var random_boss = randi_range(1,2)
		#print("spawn_boss" + str(random_boss) + "level" + str(Global.level_number))
		if random_boss == 1:
			get_tree().get_first_node_in_group("ghost_boss_group").boss_start()
		if random_boss == 2:
			get_tree().get_first_node_in_group("tank_boss_group").boss_start()
		boss_start.emit()
	print("level_number"+str(Global.level_number))
