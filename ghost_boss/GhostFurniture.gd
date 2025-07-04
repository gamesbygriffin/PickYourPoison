extends Area2D

var furniture_number: int

var scale_min = Vector2(0.1, 0.1)
var scale_max = Vector2(0.11, 0.11)
var speed = 4.0
var scale_in

@onready var boss_node = get_tree().get_first_node_in_group("ghost_boss_group")

func _ready():
	boss_node.furniture_amount += 1
	$AnimatedSprite2D.animation = str(furniture_number)
	add_to_group("furniture_group")
	position = Vector2(randi_range(100,1820),randi_range(100,980))
	scale_in = true
	scale = Vector2(0,0)
	for i in range(50):
		scale.x += 0.02
		scale.y += 0.02
		await get_tree().create_timer(0.01).timeout
	scale_in = false


func _process(delta):
	if scale_in == false:
		var t = (sin(Time.get_ticks_msec() / 1000.0 * speed) + 1.0) / 2.0
		$AnimatedSprite2D.scale = scale_min.lerp(scale_max, t)

func _on_body_entered(body):
	boss_node.furniture_amount -= 1
	boss_node.take_damage(9.5)
	for i in range(50):
		rotation -= 0.1
		scale.x -= 0.02
		scale.y -= 0.02
		await get_tree().create_timer(0.005).timeout
	queue_free()
