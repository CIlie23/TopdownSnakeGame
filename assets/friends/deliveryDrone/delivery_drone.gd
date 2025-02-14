extends Node3D

@export var rotation_speed: float = 50.0 # Speed of rotation in degrees per second
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	# Rotate the model around its Y-axis
	animation_player.play("Take 001")
	#rotate_y(deg_to_rad(rotation_speed * delta))
