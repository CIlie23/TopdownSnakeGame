extends ColorRect

@export var target : NodePath
@export var camera_distance:float = 20.0

@onready var player := get_node(target)
@onready var camera: Camera3D = $SubViewportContainer/SubViewport/Camera

func _process(delta: float) -> void:
	if target:
		camera.size = camera_distance
		camera.position = Vector3(player.position.x, camera_distance, player.position.z)
