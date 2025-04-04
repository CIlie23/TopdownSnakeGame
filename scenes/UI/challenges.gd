extends Control

@onready var coldown_timer: Timer = $ColdownTimer
@onready var title: Label = $Panel/QuestContainer/Title
@onready var lbl_time: Label = $Panel/QuestContainer/VBoxContainer/lblTime
@onready var time_left: Timer = $Panel/QuestContainer/VBoxContainer/lblTime/TimeLeft
@onready var progress_bar: ProgressBar = $Panel/QuestContainer/VBoxContainer/ProgressBar
@onready var challenges: Control = $"."
@onready var anims: AnimationPlayer = $Anims

@onready var reward_icon: TextureRect = $Panel/RewardIcon
@onready var reward_label: Label = $Panel/RewardIcon/RewardLabel

var challenge_active: bool = false
var current_challenge

func _ready() -> void:
	print("stuff started")
	#randomize()
	coldown_timer.start()
	
func _process(delta: float) -> void:
	if challenge_active and current_challenge == "killEnemies":
		if Global.total_enemy_kills == 10:
			Global.total_enemy_kills = 0
			payMoney()
			challenge_finished()
	if challenge_active and current_challenge == "killWithPlasma":
		if Global.plasma_kills == 3:
			Global.plasma_kills = 0
			payMoney()
			challenge_finished()
	if challenge_active and current_challenge == "killWithLightning":
		if Global.lightning_kills == 3:
			Global.lightning_kills = 0
			payMoney()
			challenge_finished()

func _on_coldown_timer_timeout() -> void:
	# Here we should choose between challenges
	var challenge = ["killEnemies", "stayInZone", "killWithPlasma", "killWithLightning"]
	var choice = challenge[randi() % challenge.size()]
	
	match choice:
		"killEnemies":
			killEnemies()
		"stayInZone":
			stayInZone()
		"killWithPlasma":
			killWithPlasma()
		"killWithLightning":
			killWithLightning()
	#time_left.start()
	
func _on_time_left_timeout() -> void:
	pass # when this timer is over we need to check if the challenge is done or na

func killEnemies():
	current_challenge = "killEnemies"
	challenge_active = true
	title.text = "Kill 10 enemies"
	reward_icon.texture = preload("res://assets/ui/inventory/15.png")
	reward_label.text = "100"
	
	challenge_start()
	
func stayInZone():
	current_challenge = "stayInZone"
	title.text = "Locate and capture the point"
	challenge_active = true
	challenge_start()
	
func killWithPlasma():
	current_challenge = "killWithPlasma"
	title.text = "Use Plasma Ball to kill 3 enemies with one shot"
	challenge_active = true
	challenge_start()
	
func killWithLightning():
	current_challenge = "killWithLightning"
	title.text = "Use Lightning Strike to kill 3 enemies"
	challenge_active = true
	challenge_start()
	
func challenge_start():
	print("challenge started")
	anims.play("slideIn")
	
func challenge_finished():
	coldown_timer.start()
	print("challenge finished")
	anims.play("slideOut")
	challenge_active = false 
	#challenges.visible = false

func payMoney():
	Global.money += 10
