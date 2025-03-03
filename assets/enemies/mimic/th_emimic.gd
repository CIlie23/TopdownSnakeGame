extends CharacterBody3D #Code for the mimic enemy

@onready var general_skeleton: Skeleton3D = %GeneralSkeleton
@onready var animations: AnimationPlayer = $mimic/AnimationPlayer
@onready var mimic: CharacterBody3D = $"."

var target = null
var MOVE_SPEED: float = 5.0

func _ready():
	velocity = Vector3.ZERO

func _process(delta: float) -> void:			
	if Input.is_action_pressed("killAll"):
		general_skeleton.physical_bones_start_simulation()
		animations.stop(true)
		#vfx_smoke.show()
	else:
		animations.play("mimicAnimations/idle")
		pass

func mimic_detect_Player():
	animations.play("mimicAnimations/screaming")
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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body
		#var player_pos: Vector3 = Vector3(target.global_position.x, global_position.y, global_position.z)
		
		#look_at(player_pos)
		print(body.name + "Detected")
		#mimic_detect_Player()
		pass # Replace with function body.

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = null
		print(body.name + "Lost")
		mimic_detect_Player()
		pass # Replace with function body.
