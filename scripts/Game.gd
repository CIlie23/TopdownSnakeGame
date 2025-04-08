extends Node3D

@onready var dialog: Control = $Player/UI/Dialog
@onready var pause_menu: Control = $Player/UI/PauseMenu
@onready var damage_rect: TextureRect = $Player/UI/Damage/damageRect

@onready var game_over: GameOver = $Player/UI/GameOver
@onready var exit_warning: VBoxContainer = $Player/UI/ExitWarning

@onready var timer_lbl: Label = $Player/UI/ExitWarning/TimerLbl
@onready var warning_timer: Timer = $Player/UI/ExitWarning/WarningTimer
@onready var skill_tree: Control = $Player/UI/SkillTree

const CANNON_SMALL = preload("res://scenes/turrets/cannon_small.tscn")
#@onready var inventory_ui: Control = $Player/InventoryUI
#@onready var kills_label: Label = $Player/UI/UI/AbilitiesNSuch/VBoxContainer/KillsLabel

var isPaused: bool = false
signal shader_toggled(value)
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
	if Input.is_action_just_pressed("globalPause"):
		Engine.time_scale = 0

func pauseMenu():
	if isPaused:
		#print("Hello")
		pause_menu.hide()
		#Engine.time_scale = 1
		get_tree().paused = false
	else:
		#print("Hi")
		pause_menu.show()
		#Engine.time_scale = 0
		get_tree().paused = true
	
	isPaused = !isPaused

func _on_player_player_hit() -> void:
	damage_rect.visible = true
	await get_tree().create_timer(1).timeout
	damage_rect.visible = false

func _on_player_player_dead() -> void:
	game_over.visible = true
	#Engine.time_scale = 0
	get_tree().paused = true

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

func toggle_shader(value):
	emit_signal("shader_toggled", value)


func _on_skill_tree_button_pressed() -> void:
	skill_tree.visible = not skill_tree.visible
	get_tree().paused = skill_tree.visible
