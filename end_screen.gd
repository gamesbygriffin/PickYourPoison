extends CanvasLayer

var dificulty_tracker: int
var money_tracker: int
var hp_tracker: int

var score
var boss_defeated

var set_letter_sprites = ["a+","a","b","c","d","f"]
var set_comments = [
"How!??","Insane Skills",
"Nice Job", "Great Job",
"Average Score","Maybe Next Time",
"A for Effort", "Mission Failed",
"Keep Trying", "F in the Chat"
]
var letter_ranges = [
	{ "min": 10001, "max": 10001 },
	{ "min": 8001, "max": 10000 },
	{ "min": 6001, "max": 8000 },
	{ "min": 4001, "max": 6000 },
	{ "min": 2001, "max": 4000 },
	{ "min": -1000, "max": 2000 }
] #largest to lowest max 8775

var button_pos_y: float
var score_pos_y: float

func _ready():
	button_pos_y = $Button.position.y
	score_pos_y = $ScoreLabel.position.y
	print("pos"+ str($Button.position.y) + str($ScoreLabel.position.y))
	add_to_group("end_screen_group")
	hide()
	$ScoreLabel.text = ""
	$HealthLabel.text = ""
	$MoneyLabel.text = ""
	$DifficultyLabel.text = ""
	$LevelLabel.text = ""
	$TitleLabel.text = ""
	$BossLabel.text = ""
	$Button.hide()

func _process(delta):
	#money_tracker = Global.tri_money
	pass

func update_score():
	$ScoreLabel.text = ""
	$HealthLabel.text = ""
	$MoneyLabel.text = ""
	$DifficultyLabel.text = ""
	$LevelLabel.text = ""
	$TitleLabel.text = ""
	$BossLabel.text = ""
	$Button.hide()
	$LetterSprite.hide()
	show()
	
	var money_score
	var hp_score
	
	if money_tracker/8 == 0:
		money_score = 1
	else:
		money_score = money_tracker/8
	if hp_tracker <= 0:
		hp_score = 8
		score = dificulty_tracker * money_score * 8 * Global.level_number * 1.5
	else:
		hp_score = ((13-hp_tracker)/2)
		score = dificulty_tracker * money_score * ((13-hp_tracker)/2) * Global.level_number * 1.5
	
	if boss_defeated == false:
		$BossLabel.hide()
		$ScoreLabel.position.y = 712
		$Button.position.y = 811
	elif boss_defeated:
		$BossLabel.show()
		$ScoreLabel.position.y = 805
		$Button.position.y = 905
		score += 1000
	
	if score >= 10000:
		score = 10000
		if boss_defeated == true:
			score = 10001
			print("score_boss" + str(score)) 
	
	print("money_tracker="+str(money_tracker) + ",money=" + str(ceil(money_tracker/4))) 
	
	#score = 15 * 15 * 6.5 * 6
	for i in range(letter_ranges.size()):
		var r = letter_ranges[i]
		if score >= r.min and score <= r.max:
			$LetterSprite.animation = str(set_letter_sprites[i])
			break
	var comment
	if $LetterSprite.animation == "a+":
		comment = "..."
		$LetterSprite.position.x -= 90
	if $LetterSprite.animation == "a":
		comment = set_comments[randi_range(0,1)]
	if $LetterSprite.animation == "b":
		comment = set_comments[randi_range(2,3)]
	if $LetterSprite.animation == "c":
		comment = set_comments[randi_range(4,5)]
	if $LetterSprite.animation == "d":
		comment = set_comments[randi_range(6,7)]
	if $LetterSprite.animation == "f":
		comment = set_comments[randi_range(8,9)]
	print(comment)
	await display_letters(str(comment), $TitleLabel)
	await display_letters("Dificulty Multiplier x" + str(dificulty_tracker), $DifficultyLabel)
	await display_letters("Health & Damage Taken x" + str(hp_score), $HealthLabel)
	await display_letters("Money Maker x" + str(money_score), $MoneyLabel)
	await display_letters("Level Achieved x" + str(Global.level_number * 1.5), $LevelLabel)
	if boss_defeated  == true:
		await display_letters("Boss Slayer +1000", $BossLabel)
	await display_letters("Score: " + str(score), $ScoreLabel)
	$LetterSprite.scale = Vector2.ZERO
	$LetterSprite.show()
	await scale_in($LetterSprite,Vector2(0.49,0.49))
	
	$Button.show()
	#$Button.scale = Vector2.ZERO
	#for i in range(50):
	#	$Button.scale.x += 0.02
	#	$Butto n.scale.y += 0.02
	#	await get_tree().create_timer(0.01).timeout
	$Button.scale = Vector2.ONE


func display_letters(text: String, label: Label):
	label.text = ""
	var temp_text = ""
	for i in range(text.length()):
		temp_text += text[i]
		label.text = temp_text
		await get_tree().create_timer(0.03).timeout
	await get_tree().create_timer(0.1).timeout

#await get_tree().create_timer(0.00001).timeout

func scale_in(node: Node2D, target_scale: Vector2, speed: float = 5.0) -> void:
	while node.scale.distance_to(target_scale) > 0.01:
		node.scale = node.scale.lerp(target_scale, speed * get_process_delta_time())
		await get_tree().process_frame
	node.scale = target_scale

func _on_hud_start_game():
	boss_defeated = false
	money_tracker = 0
	dificulty_tracker = 0
	hp_tracker = 0
"""
	$LetterSprite.show()
	$LetterSprite.scale = Vector2.ZERO
	for i in range(50):
		$LetterSprite.scale.x += 0.02
		$LetterSprite.scale.y += 0.02
		await get_tree().create_timer(0.01).timeout
	$Button.show()
	$LetterSprite.scale = Vector2.ZERO
	for i in range(50):
		$Button.scale.x += 0.02
		$Button.scale.y += 0.02
		await get_tree().create_timer(0.01).timeout
"""

func _on_button_pressed():
	hide()
