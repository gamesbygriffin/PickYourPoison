extends Area2D

var beam_on = false
var amplitude = 75
var speed = 2.0
var move_speed = 200
var center_position = 400
var time = 0.0

func _ready():
	center_position = randf_range(100,980)
	position = Vector2(2000,center_position)
	$Timer.start()

func _process(delta):
	if Global.in_game == true:
		if beam_on == false:
			$BeamSprite.hide()
			$BeamDetector.disabled = true
		else:
			$BeamSprite.show()
			$BeamDetector.disabled = false
		time += speed * delta
		position.y = center_position + sin(time) * amplitude
		position.x -= move_speed * delta

func _on_timer_timeout():
	if beam_on == false:
		beam_on = true
	else:
		beam_on = false
