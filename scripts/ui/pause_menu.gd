extends Control

@onready var mainScene = $"../../../"


func _on_resume_pressed() -> void:
	mainScene.pauseMenu()
	#Engine.time_scale = 1

func _on_main_menu_pressed() -> void:
	#get_tree().current_scene.queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
