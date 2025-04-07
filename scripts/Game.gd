extends Node3D

@onready var dialog: Control = $Player/UI/Dialog
@onready var pause_menu: Control = $Player/UI/PauseMenu
@onready var damage_rect: TextureRect = $Player/UI/Damage/damageRect

@onready var game_over: GameOver = $Player/UI/GameOver
@onready var exit_warning: VBoxContainer = $Player/UI/ExitWarning

@onready var timer_lbl: Label = $Player/UI/ExitWarning/TimerLbl
@onready var warning_timer: Timer = $Player/UI/ExitWarning/WarningTimer

const CANNON_SMALL = preload("res://scenes/turrets/cannon_small.tscn")
#@onready var inventory_ui: Control = $Player/InventoryUI
#@onready var kills_label: Label = $Player/UI/UI/AbilitiesNSuch/VBoxContainer/KillsLabel

var isPaused: bool = false

func _ready() -> void:
	#dialog.display_line("Hello world!", "Admin")
	pass

func _process(delta):
	#kills_label.text = str(Global.total_enemy_kills)
	timer_lbl.text = "%.1f" % warning_timer.time_left
	if warning_timer.time_left <= 10.0:
		timer_lbl.modulate = Color.RED
	else:
		timer_lbl.modulate = Color.WHITE
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if isPaused:
		#print("Hello")
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		#print("Hi")
		pause_menu.show()
		Engine.time_scale = 0
	
	isPaused = !isPaused

func _on_player_player_hit() -> void:
	damage_rect.visible = true
	await get_tree().create_timer(1).timeout
	damage_rect.visible = false

func _on_player_player_dead() -> void:
	game_over.visible = true
	Engine.time_scale = 0

func _on_arena_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		warning_timer.start()
		exit_warning.visible = true
		print("player exited")
	if body.is_in_group("Enemy"):
		body.queue_free()
		print("enemy deleted")
		print(Global.total_enemies)
		Global.total_enemies -= 1
		

func _on_arena_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		warning_timer.stop()
		exit_warning.visible = false
		print("player exited")
		
func _on_warning_timer_timeout() -> void:
	warning_timer.stop()
	print("uh oh")
