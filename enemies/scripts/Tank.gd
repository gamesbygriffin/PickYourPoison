extends Area2D

@export var bullet_scene: PackedScene

var speed = 200
var shooting = false

func _ready():
	$Timer.start()

func _process(delta):
	if Global.in_game == true:
		if shooting == false:
			position.x -= speed * delta
		else:
			pass

func _on_timer_timeout():
	if Global.in_game == true:
		$Timer.stop()
		shooting = true
		await get_tree().create_timer(0.5).timeout
		var bullet = bullet_scene.instantiate()
		bullet.position = $Marker2D.position
		add_child(bullet)
		await get_tree().create_timer(0.7).timeout
		shooting = false
		$Timer.start()
