extends Node3D

@onready var dialog: Control = $Player/UI/Dialog
@onready var pause_menu: Control = $Player/PauseMenu

@onready var damage_rect: ColorRect = $Player/Damage/ColorRect

const CANNON_SMALL = preload("res://scenes/turrets/cannon_small.tscn")
@onready var inventory_ui: Control = $Player/InventoryUI

var isPaused: bool = false

func _ready() -> void:
	#dialog.display_line("Hello world!", "Admin")
	pass

func _process(delta):
	#print("Process running...")
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

func _on_inventory_ui_item_out_of_inventory() -> void:
	print("now we should be in the main scene")
	#CANNON_SMALL.instantiate()
	#inventory_ui.modulate.a = 0.5

func _on_player_player_hit() -> void:
	damage_rect.visible = true
	await get_tree().create_timer(1).timeout
	damage_rect.visible = false
