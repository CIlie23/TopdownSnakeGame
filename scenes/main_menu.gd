extends Node2D

@onready var popup: Panel = $Popup
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var settings: Control = $SettingsPannel
var isSettingsOn: bool = false
#var shader = get_node("/root/Spacial/Player/Shader")
var shader: Node
@onready var lbl_keybind: Label = $SettingsPannel/Settings/Keybinds/lblKeybind

@onready var up_input: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/KeybindContainer/Move Up/upInput"
@onready var down_input: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/KeybindContainer/Move Down/downInput"
@onready var left_input: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/KeybindContainer/Move Left/leftInput"
@onready var right_input: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/KeybindContainer/Move Right/rightInput"

@onready var abil_one: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/VBoxContainer/Ability One/abilOne"
@onready var abil_two: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/VBoxContainer/Ability Two/abilTwo"
@onready var abil_three: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/VBoxContainer/Ability Three/abilThree"
@onready var abil_four: Button = $"SettingsPannel/Settings/Keybinds/HBoxContainer/VBoxContainer/Ability Four/abilFour"

@onready var btn_skill_teee: Button = $SettingsPannel/Settings/Keybinds/SkillTree/btnSkillTeee

@onready var settingsButton: Button = $VBoxContainer/Settings
@onready var audio: AudioStreamPlayer = $Audio
@onready var tutorial: Control = $Tutorial


#
#func _ready() -> void:
	#audio.play()
	
func _process(delta: float) -> void:
	if isSettingsOn == true:
		settingsButton.disabled = true
	else:
		settingsButton.disabled = false
		
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
func _on_settings_pressed() -> void:
	isSettingsOn = true
	animation.play("title_MoveLeft")
	settings.visible = true
	
func _on_quit_pressed() -> void:
	popup.visible = true
	isSettingsOn = false
	animation.play("title_MoveCenter")
	settings.visible = false
	
func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	popup.visible = false


func _on_button_pressed() -> void:
	isSettingsOn = false
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


func _on_vsync_op_item_selected(index: int) -> void:
	if index == 0: # Disabled (default)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	elif index == 1: # Adaptive
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	elif index == 2: # Enabled
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

var waiting_for_input = false
var action_to_change = ""


func _unhandled_input(event):
	if waiting_for_input and event is InputEventKey and event.pressed:
		var key_name = OS.get_keycode_string(event.keycode)
		# Replaces existing key for the action
		InputMap.action_erase_events(action_to_change)
		InputMap.action_add_event(action_to_change, event)
		
		lbl_keybind.text = ""
		match action_to_change:
			"game_up":
				up_input.text = key_name
			"game_down":
				down_input.text = key_name
			"game_left":
				left_input.text = key_name
			"game_right":
				right_input.text = key_name
			"ability_one":
				abil_one.text = key_name
			"ability_two":
				abil_two.text = key_name
			"ability_tree":
				abil_three.text = key_name
			"ability_four":
				abil_four.text = key_name
			"openskilltree":
				btn_skill_teee.text = key_name
		# Reset
		waiting_for_input = false
		action_to_change = ""

# Called when the "Change Key" button is pressed
func on_change_key_pressed(action_name):
	waiting_for_input = true
	action_to_change = action_name
	lbl_keybind.text = "Listening for new input: " + action_name

func _on_up_input_pressed() -> void:
	on_change_key_pressed("game_up")

func _on_down_input_pressed() -> void:
	on_change_key_pressed("game_down")

func _on_left_input_pressed() -> void:
	on_change_key_pressed("game_left")

func _on_right_input_pressed() -> void:
	on_change_key_pressed("game_right")

func _on_abil_one_pressed() -> void:
	on_change_key_pressed("ability_one")

func _on_abil_two_pressed() -> void:
	on_change_key_pressed("ability_two")

func _on_abil_three_pressed() -> void:
	on_change_key_pressed("ability_tree")

func _on_abil_four_pressed() -> void:
	on_change_key_pressed("ability_four")

func _on_psx_shader_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _on_btn_skill_teee_pressed() -> void:
	on_change_key_pressed("openskilltree")

func _on_how_to_play_pressed() -> void:
	tutorial.visible = true
