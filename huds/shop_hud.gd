extends CanvasLayer

@export var shop_item_scene: PackedScene

func _ready():
	hide()
	$ExitButton.modulate.a = 0.0
	var pos_y = 0
	for i in range(2):
		var pos_x = 0
		for k in range(4):
			var shop_item = shop_item_scene.instantiate()
			shop_item.position = Vector2(200+pos_x,220 + pos_y)
			shop_item.hat_index =  i * 4 + k
			#print(i * 4 + k)
			add_child(shop_item)
			pos_x += 400
		pos_y += 400

func _process(delta):
	$MoneyLabel.text = str(Global.cir_money)

func _on_exit_button_pressed():
	hide()

func _on_shop_button_pressed():
	if visible == false:
		show()
	elif visible == true:
		hide()

func _on_hud_start_game():
	hide()
