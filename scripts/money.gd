extends Node3D # Replace 'Node3D' with the base node type of your 3D model, e.g., MeshInstance3D

@export var rotation_speed: float = 50.0 # Speed of rotation in degrees per second
@onready var outline: MeshInstance3D = $"C01-cns-lg/outline"
@onready var dialog: Control = $"../Player/UI/Dialog"

var cursorQuestion = preload("res://assets/cursors/mark_question_pointer_b.png")
var cursorNormal = preload("res://assets/cursors/pointer_b.png")
var cursorExclamation = preload("res://assets/cursors/mark_exclamation_pointer_b.png")

func _ready():
	outline.visible = false  # Hide outline by default
	
func _process(delta: float) -> void:
	# Rotate the model around its Y-axis
	rotate_y(deg_to_rad(rotation_speed * delta))

func _on_area_3d_mouse_entered() -> void:
	outline.visible = true
	Input.set_custom_mouse_cursor(cursorQuestion)
	#print("im in")

func _on_area_3d_mouse_exited() -> void:
	outline.visible = false
	Input.set_custom_mouse_cursor(cursorNormal)
	#print("im out")

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#dialog.display_line("Hello this is the money [wave]calling[/wave]", "The money") #while using the cool formating it takes time for the text to show up for some reason
			dialog.display_line("[wave]Hello this is the money calling[/wave]", "The money")
