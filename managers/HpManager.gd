extends Node

@export var heart_scene: PackedScene
@export var max_hp: int = 100

var current_hp: int
var hearts = []
var dead_check = true

signal player_dead

func _ready():
	add_to_group("hp_manager_group")
	create_hearts()

func _on_hud_start_game():
	Global.player_hp = 3
	#Global.player_hp = 30
	#Global.cir_money = 100
	dead_check = true

func _process(delta):
	#if Global.in_game == false:
	#	var heart_group = get_tree().get_nodes_in_group("level_manager_group")
	#	for heart in heart_group:
	#		heart.hide()
	#else:
	#	var heart_group = get_tree().get_nodes_in_group("level_manager_group")
	#	for heart in heart_group:
	#		heart.show()
	current_hp = Global.player_hp
	for i in range(max_hp):
		hearts[i].visible = i < current_hp
	if dead_check and Global.player_hp <= 0 and Global.in_game == true:
		dead_check = false
		player_dead.emit()
		get_tree().get_first_node_in_group("end_screen_group").update_score()
		Global.in_game = false


func create_hearts():
	for i in range(max_hp):
		var heart = heart_scene.instantiate()
		add_child(heart)
		heart.add_to_group("heart_group")
		heart.position = Vector2(60 + i * 100, 60)
		hearts.append(heart)


"""
func take_damage(amount):
	current_hp = max(0, current_hp - amount)
	update_hearts()

func heal(amount):
	current_hp = min(max_hp, current_hp + amount)
	update_hearts()
"""


