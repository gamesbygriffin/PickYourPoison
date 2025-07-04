extends CanvasLayer

func _process(delta):
	$TriLabel.text = str(Global.tri_money)
	$CirLabel.text = str(Global.cir_money)
	if Global.game_level == 6:
		$BossLabel.show()
	else:
		$BossLabel.hide()
