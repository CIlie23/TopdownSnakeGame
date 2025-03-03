extends Skeleton3D #Code for the mimic enemy

@onready var skeleton: Skeleton3D = %GeneralSkeleton
@onready var animations: AnimationPlayer = $"../AnimationPlayer"

var target = null
var MOVE_SPEED: float = 5.0

func _ready():
	pass

func _process(delta: float) -> void:	
	if Input.is_action_pressed("killAll"):	
		skeleton.physical_bones_start_simulation()
		print("hello")
		#animations.stop(true)
	else:
		animations.play("mimicAnimations/idle")
		
func override_bone_transforms():
	for i in range(skeleton.get_bone_count()):
		var bone_transform = skeleton.get_bone_global_pose(i) # Get current transform
		skeleton.set_bone_global_pose_override(i, bone_transform, 1.0, true) # Override it
