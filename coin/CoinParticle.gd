extends RigidBody2D

@export var min_force: float = 300
@export var max_force: float = 500
@export var spread_angle: float = 70 

var sprite_number: int

func _ready():
	z_index = 3
	var scale_vector = randf_range(0.1, 0.1)
	$Sprite.animation = str(sprite_number)
	$Sprite.scale = Vector2(scale_vector, scale_vector)
	$Sprite.rotation = deg_to_rad(randf_range(360,0))
	var angle = deg_to_rad(randf_range(-spread_angle / 2, spread_angle / 2))
	var force = randf_range(min_force, max_force)
	var direction = Vector2(0, -1).rotated(angle)  
	apply_impulse(direction * force)
