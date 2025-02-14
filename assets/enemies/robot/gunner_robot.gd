extends Node3D

@export var rotation_speed: float = 50.0 # Speed of rotation in degrees per second
@onready var general_skeleton: Skeleton3D = %GeneralSkeleton
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var vfx_fire: Node3D = $"XRKArmature/GeneralSkeleton/Physical Bone Chest/vfx_Fire"

func _process(delta: float) -> void:
	if Input.is_action_pressed("killAll"):
		general_skeleton.physical_bones_start_simulation()
		animations.stop(true)
		vfx_fire.show()
	else:
		animations.play("GunnerAnimations/run forward")
