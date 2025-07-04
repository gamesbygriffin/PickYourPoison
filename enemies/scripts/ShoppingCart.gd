extends Area2D

@export var shopping_item: PackedScene

var speed = 25
var acceleration: int

func _ready():
	$Timer.start()
	position = Vector2(2000,randf_range(100,980))
	speed = randi_range(150,225)

func _process(delta):
	if Global.in_game == true:
		position.x -= (speed + acceleration) * delta
		acceleration += 3

func _on_timer_timeout():
	var item = shopping_item.instantiate()
	item.rotation = deg_to_rad(randi_range(0,360))
	item.position = Vector2(position.x, position.y + 30)
	get_parent().add_child(item)
