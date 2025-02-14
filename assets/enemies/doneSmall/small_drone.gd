extends Node3D

@onready var skeleton_3d: Skeleton3D = $Drone1_Armature/Skeleton3D
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var vfx_fire: Node3D = $"Drone1_Armature/Skeleton3D/Physical Bone Body/vfx_Fire"

func _ready() -> void:
	#skeleton_3d.physical_bones_start_simulation()
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("killAll"):
		skeleton_3d.physical_bones_start_simulation()
		animations.stop(true)
		vfx_fire.show()
	else:
		animations.play("idle")
