extends Camera2D
 
var target_position = Vector2.ZERO

func _ready():
	make_current()


func _process(delta):
	aquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 5))
	global_position = global_position.round()


func aquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player_group")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
