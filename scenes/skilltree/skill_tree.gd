extends Control

@onready var points: Label = $Points
@onready var panel: Panel = $"TabContainer/Player Upgrades/Panel"
#@onready var panel: Panel = $"TabContainer/Player Upgrades/ChoicePopup"

#@export var player = preload("res://scenes/world/player.tscn")
@export var player = load("res://scenes/world/player.tscn")
var is_skilltree_open = false
@onready var skill_tree: Control = $"."
@onready var yesBtn: Button = $"TabContainer/Player Upgrades/Panel/Label/HBoxContainer/Yes"


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta: float) -> void:
	points.text = ("Available Points: " + str(Global.available_skpoints))
	if Input.is_action_just_pressed("openskilltree"):
		if !is_skilltree_open:
			#Engine.time_scale = 0
			get_tree().paused = true
			opened()
		else:
			#Engine.time_scale = 1
			get_tree().paused = false
			closed()

func opened():
	visible = true
	is_skilltree_open = true
	
func closed():
	visible = false
	is_skilltree_open = false

func _on_increase_size_pressed() -> void:
	panel.visible = true

func _on_yes_pressed() -> void:
	if Global.available_skpoints <= 0:
		return
	var player = get_tree().get_root().get_node("Spacial/Player")  # Adjust path as needed
	player.extend()
	
	Global.available_skpoints -= 10
	skill_tree.visible = false
	panel.visible = false


func _on_no_pressed() -> void:
	panel.visible = false
