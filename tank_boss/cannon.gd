extends Area2D

var cannon_direction: Vector2
var cannon_charge
var rotate_speed: float = 2.0

@export var cannon_ball_scene: PackedScene

@onready var player = get_tree().get_first_node_in_group("player_group")

func _ready():
	show()
	add_to_group("cannon_group")
	cannon_charge = 0

func _process(delta):
	$ChargeBar.value = cannon_charge
	if player.in_cannon == true and player.current_cannon == self:
		if cannon_charge < 100.0:
			cannon_charge += 0.2
		if Input.is_action_pressed("left_click") and cannon_charge >= 100.0:
			cannon_charge = 0.0
			var cannon_ball = cannon_ball_scene.instantiate()
			cannon_ball.position = $Rotatable/CannonMarker.global_position
			cannon_ball.direction = cannon_direction
			cannon_ball.add_to_group("cannon_ball_group")
			get_parent().add_child(cannon_ball)
		var mouse_pos = get_global_mouse_position()
		var to_mouse = (mouse_pos - $Rotatable.global_position).normalized()
		var target_angle = to_mouse.angle()
		var current_angle = $Rotatable.rotation
		var new_angle = lerp_angle(current_angle, target_angle, delta * rotate_speed)
		$Rotatable.rotation = new_angle
		cannon_direction = Vector2.RIGHT.rotated(new_angle)
	else:
		if cannon_charge > 0.0:
			cannon_charge -= 0.05
