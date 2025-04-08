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
	if not challenge_active:
		return
	
	lbl_time.text = "Time left: " + "%.1f" % time_left.time_left
	
	match current_challenge:
		"killEnemies":
			progress_bar.value = Global.total_enemy_kills
			if Global.total_enemy_kills >= 10:
				Global.total_enemy_kills = 0
				payMoney()
				challenge_finished()

		"killWithPlasma":
			progress_bar.value = Global.plasma_kills
			if Global.plasma_kills >= 3:
				Global.plasma_kills = 0
				payMoney()
				challenge_finished()

		"killWithLightning":
			progress_bar.value = Global.lightning_kills
			if Global.lightning_kills >= 3:
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
			stayInZone()		#"killEnemies":
			#killEnemies()
		"killWithPlasma":
			killWithPlasma()
		"killWithLightning":
			killWithLightning()
	#time_left.start()
	
func _on_time_left_timeout() -> void:
	# when this timer is over we need to check if the challenge is done or na
	challenge_failed()
	
func killEnemies():
	time_left.wait_time = 30
	time_left.start()
	
	current_challenge = "killEnemies"
	challenge_active = true
	title.text = "Kill 10 enemies"
	progress_bar.max_value = 10
	reward_icon.texture = preload("res://assets/ui/inventory/15.png")
	reward_label.text = "100"
	
	challenge_start()
	
func stayInZone():
	time_left.wait_time = 40
	time_left.start()
	current_challenge = "stayInZone"
	title.text = "Locate and capture the point"
	challenge_active = true
	challenge_start()
	
	var point_scene = preload("res://scenes/world/capture_point.tscn")
	var capture_point = point_scene.instantiate()
	get_tree().get_root().add_child(capture_point)
	
	if not capture_point.capturing_progress.is_connected(_on_capture_progress):
		capture_point.capturing_progress.connect(_on_capture_progress)

#sorta works, cleanup and finish l8r
func _on_capture_progress(progress: float):
	time_left.paused = true
	progress_bar.value = progress * 10.0
	if progress >= 1.0:
		print(progress)
		challenge_finished()
	
func killWithPlasma():
	time_left.wait_time = 30
	time_left.start()
	progress_bar.max_value = 3
	current_challenge = "killWithPlasma"
	title.text = "Use Plasma Ball to kill 3 enemies!"
	challenge_active = true
	challenge_start()
	
func killWithLightning():
	time_left.wait_time = 30
	time_left.start()
	progress_bar.max_value = 3
	current_challenge = "killWithLightning"
	title.text = "Use Lightning Strike to kill 3 enemies!"
	challenge_active = true
	challenge_start()
	
func challenge_start():
	print("challenge started")
	anims.play("slideIn")
	
func challenge_finished():
	progress_bar.value = 0
	coldown_timer.start()
	print("challenge finished")
	anims.play("slideOut")
	challenge_active = false 
	#challenges.visible = false

func challenge_failed():
	anims.play("slideOut") 
	challenge_active = false
	coldown_timer.start()
	lbl_time.text = "Challenge Failed."
	
func payMoney():
	Global.money += 10
