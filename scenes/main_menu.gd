extends Node2D

@onready var popup: Panel = $Popup
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var settings: Control = $SettingsPannel
#var shader = get_node("/root/Spacial/Player/Shader")
var shader: Node

func _ready() -> void:
		shader = get_node("/root/Spacial/Player/Shader")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_settings_pressed() -> void:
	animation.play("title_MoveLeft")
	settings.visible = true
	
func _on_quit_pressed() -> void:
	popup.visible = true
	
func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	popup.visible = false


func _on_button_pressed() -> void:
	animation.play("title_MoveCenter")
	settings.visible = false


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1600,900))
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))
		2:
			DisplayServer.window_set_size(Vector2i(1024,768))
		3:
			DisplayServer.window_set_size(Vector2i(640,480))


func _on_full_screen_check_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_psx_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		shader.visible = true
	else:
		shader.visible = false
