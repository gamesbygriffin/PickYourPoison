extends Area2D

var velocity
var deceleration
var stored_value

var key_value
var bomb_type
var direction := Vector2.LEFT

func _ready():
	$Sprite2D.scale = Vector2(0.1, 0.1)
	rotation = deg_to_rad(randf_range(0,360))
	if bomb_type == "level":
		position = Vector2(2000, randf_range(100, 980))
		velocity = randf_range(500, 1000)
		deceleration = randf_range(200, 300)
	if bomb_type == "boss":
		velocity = 670
		deceleration = 400

func _process(delta):
	if Global.in_game == true:
		if bomb_type == "boss":
			if velocity > 0:
				$CollisionShape2D.disabled = true
				var move_step = direction.normalized() * velocity * delta
				position += move_step
				rotation += velocity * 0.005 * delta
				velocity -= deceleration * delta
				if velocity <= 0:
					velocity = 0
					rotation = lerp_angle(rotation, 0, delta * 5)
					$AnimationPlayer.play("explode")
					await get_tree().create_timer(1.4).timeout
					$CollisionShape2D.disabled = false
					await get_tree().create_timer(0.6).timeout
					queue_free()
	
		if bomb_type == "level":
			if velocity > 0:
				$CollisionShape2D.disabled = true
				velocity -= deceleration * delta
				position.x -= velocity * delta
				rotation -= velocity * 0.01 * delta
				if velocity < 0:
					velocity = 0
					rotation = lerp_angle(rotation, 0, delta * 5)
					$AnimationPlayer.play("explode")
					await get_tree().create_timer(1.4).timeout 
					$CollisionShape2D.disabled = false
					await get_tree().create_timer(0.6).timeout
					queue_free()
					#smooth_turn_to_zero_degrees(delta)


func smooth_turn_to_zero_degrees(delta):
	rotation = lerp_angle(rotation, 0, delta * 5)


"""
func get_key_track():
	if animation_player.has_animation("my_animation"):
		var anim = animation_player.get_animation("my_animation")
		if anim.get_track_count() > 1:
			var track_index = 1
			if anim.get_key_track(track_index) > 0:
				key_value = anim.track_get_key_value(track_index, rotation)
	print(key_value)
"""
