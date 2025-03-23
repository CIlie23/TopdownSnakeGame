extends Node3D

@onready var skeleton_3d: Skeleton3D = $wTube_002/Skeleton3D

func _ready() -> void:
	skeleton_3d.physical_bones_start_simulation()
