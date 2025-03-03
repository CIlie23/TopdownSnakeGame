extends Node3D

@onready var turret_area: Area3D = $TurretArea
@onready var shoot_timer: Timer = $ShootTimer
@onready var rifle_barrel: MeshInstance3D = $MeshInstance3D/MeshInstance3D

var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance

var target = null
var state = IDLE
var rotation_speed = 40

enum {
	IDLE,
	DETECT,
}
func _process(delta: float) -> void:
	match state:
		IDLE:
			print("I work")
		DETECT:
			_rotate_towards_target()
			#rifle_barrel.global_position.direction_to(Vector3(target.global_position.x, global_position.y, target.global_position.z))
			#look_at(target.global_transform.origin, Vector3.UP)

func _physics_process(delta):
	if target: #if the target is in range
		look_at(target.global_transform.origin, Vector3.UP)
		##rotate_y(deg_to_rad(180)) #turns model 180 degrees cause for some reason it's fillped?
		##velocity = position.direction_to(target.position) * MOVE_SPEED
		#pass
	#else:
		#velocity = Vector3.ZERO  # Ensure no unintended movement
	##velocity = velocity.limit_length(MOVE_SPEED) 
	#
	#move_and_slide()
#----------------------------------------------------------------------------
# Turret Detecting
#----------------------------------------------------------------------------
func _on_turret_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		state = DETECT
		target = body
		shoot_timer.start()
		print(body.name + " Spotted")

func _on_turret_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		target = null
		shoot_timer.stop()

func _rotate_towards_target():
	print("Looking")
	#look_at(target.global_transform.origin, Vector3.UP)
#----------------------------------------------------------------------------
# Shooting
#----------------------------------------------------------------------------
func _on_shoot_timer_timeout() -> void:
	instance = bullet.instantiate()
	instance.position = rifle_barrel.global_position
	instance.transform.basis = rifle_barrel.global_transform.basis
	get_parent().add_child(instance)
