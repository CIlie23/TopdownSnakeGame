extends Node3D

@onready var dialog: Control = $Player/UI/Dialog
@onready var pause_menu: Control = $Player/UI/PauseMenu

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
		print("Hello")
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		print("Hi")
		pause_menu.show()
		Engine.time_scale = 0
	
	isPaused = !isPaused
