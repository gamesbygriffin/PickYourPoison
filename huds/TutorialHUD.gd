extends CanvasLayer

var tutorial_number = 0

func _ready():
	
	$Sprite1.add_to_group("tutorial_sprites")
	$Sprite2.add_to_group("tutorial_sprites")
	$Sprite3.add_to_group("tutorial_sprites")
	$Sprite4.add_to_group("tutorial_sprites")
	$Sprite5.add_to_group("tutorial_sprites")
	for sprite in get_tree().get_nodes_in_group("tutorial_sprites"):
		sprite.hide()
		#sprite.pivot_offset = sprite.size / 2

func start_turtorial():
	for sprite in get_tree().get_nodes_in_group("tutorial_sprites"):
		sprite.hide()
	tutorial_number = 0
	show()

func _process(delta):
	pass

func display_tutorial(tutorial_sprite: Node):
	tutorial_sprite.show()
	await scale_in(tutorial_sprite, Vector2(0.2, 0.2))

func scale_in(node: Node2D, target_scale: Vector2, speed: float = 5.0) -> void:
	node.scale = Vector2.ZERO
	node.show()
	while node.scale.distance_to(target_scale) > 0.01:
		node.scale = node.scale.lerp(target_scale, speed * get_process_delta_time())
		await get_tree().process_frame
	node.scale = target_scale

func scale_out(node: Node2D, current_scale: Vector2, speed: float = 5.0) -> void:
	node.scale = current_scale
	node.show()
	while node.scale.distance_to(Vector2.ZERO) > 0.01:
		node.scale = node.scale.lerp(Vector2.ZERO, speed * get_process_delta_time())
		await get_tree().process_frame
	node.scale = Vector2.ZERO
	node.hide()

func _on_next_button_pressed():
	tutorial_number += 1
	if tutorial_number >= 6:
		hide()
		if get_parent().tutorial_show == false:
			get_parent().tutorial_show = true
			get_parent()._on_button_pressed()
		return
	if tutorial_number == 4:
		$Sprite1.hide()
		$Sprite2.hide()
		$Sprite3.hide()
	display_tutorial(get_node("Sprite"+str(tutorial_number)))

func _on_back_button_pressed():
	if tutorial_number == 0:
		tutorial_number = 0
		return
	if tutorial_number == 4:
		$Sprite1.show()
		$Sprite2.show()
		$Sprite3.show()
	get_node("Sprite"+str(tutorial_number)).hide()
	tutorial_number -= 1
