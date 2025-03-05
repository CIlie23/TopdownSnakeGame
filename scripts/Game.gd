extends Node3D

@onready var dialog: Control = $Player/UI/Dialog
@onready var pause_menu: Control = $Player/UI/PauseMenu
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
