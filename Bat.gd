extends Area2D

func _ready():
	$Area2D/CollisionShape2D.disabled = true
	$Area2D.add_to_group("bat_group")

func _process(delta):
	#if Input.is_action_pressed("bat_swing"):
	#	$AnimationPlayer.play("swing")
	#	$Area2D/CollisionShape2D.disabled = false
	#	await get_tree().create_timer(0.5).timeout
	#	$Area2D/CollisionShape2D.disabled = true
	look_at(get_global_mouse_position())
	
	#if rotation_degrees > 90 or rotation_degrees < -90:
	#	$Area2D.scale.y = -1
	#else:
	#	$Area2D.scale.y = 1
