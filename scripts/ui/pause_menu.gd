extends Control

@onready var mainScene = $"../../../"

func _on_resume_pressed() -> void:
	mainScene.pauseMenu()


func _on_main_menu_pressed() -> void:
	get_tree().quit()
