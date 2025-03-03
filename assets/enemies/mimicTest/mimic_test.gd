extends CharacterBody3D

@onready var general_skeleton: Skeleton3D = %GeneralSkeleton
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var boneSim: PhysicalBoneSimulator3D = $SK_DLC_Old_Endo/GeneralSkeleton/PhysicalBoneSimulator3D


var target = null
var MOVE_SPEED: float = 5.0

func _ready():
	general_skeleton.set_process(false)
	#general_skeleton.physical_bones_stop_simulation()
	velocity = Vector3.ZERO
	
func _process(delta: float) -> void:			
	if Input.is_action_pressed("killAll"):
		general_skeleton.physical_bones_start_simulation()
		animations.stop(true)
		#vfx_smoke.show()
	else:
		#general_skeleton.physical_bones_stop_simulation()
		#animations.play("mimicAnimations/idle")
		pass

func mimic_detect_Player():
	#animations.play("mimicAnimations/screaming")
	print("hello")
	pass

func _physics_process(delta):
	if target:
		look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(180)) #turns model 180 degrees cause for some reason it's fillped?
		velocity = position.direction_to(target.position) * MOVE_SPEED
	else:
		velocity = Vector3.ZERO  # Ensure no unintended movement
		pass
	velocity = velocity.limit_length(MOVE_SPEED) 
	
	move_and_slide()

func _on_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body
		#general_skeleton.physical_bones_stop_simulation()
		animations.play("mimicAnimations/floor crawl")
		print(body.name + "Detected")
		#mimic_detect_Player()
		pass # Replace with function body.


func _on_detect_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = null
		print(body.name + "Lost")
		animations.play("mimicAnimations/idle")
		mimic_detect_Player()
		pass # Replace with function body.
