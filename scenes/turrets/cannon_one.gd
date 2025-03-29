extends Node3D

@onready var barrel: RayCast3D = $Barrel
@onready var shoot_timer: Timer = $ShootTimer
@onready var turret_head: MeshInstance3D = $Turret_Cannon_Top
#@onready var turret_head: MeshInstance3D = $turret_double

var target = null
var bullet = load("res://scenes/turrets/turretBullet.tscn")
var cannon_bullet
var can_shoot = true 

func _ready() -> void:
	print("Cannon Loaded!")

func _process(delta: float) -> void:
	if barrel.is_colliding() and can_shoot:
		#shoot_timer.start()
		can_shoot = false
	rotate_towards_target()
	
func rotate_towards_target():
	if target == null:
		pass
	else:
		#turret_head.look_at(target.global_transform.origin, Vector3.UP)
		turret_head.look_at(target.global_transform.origin)
		turret_head.rotate_y(deg_to_rad(180))  # Adjust depending on model orientation
		#turret_head.rotate_x(deg_to_rad(-90)) 
		#turret_head.rotate_y(deg_to_rad(180))
#----------------------------------------------------------------------------
# Turret Detection Logic
#----------------------------------------------------------------------------
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"): #checking if the raycast is coliding so it doesn't shoot at random
		#head.look_at(target.global_transform.origin, Vector3.UP)
		target = body
		can_shoot = true
		print(body.name + " Detected")

func _on_area_3d_body_exited(body: Node3D) -> void:
	target = null
	#shoot_timer.stop()
	print(body.name + " Lost :(")

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
	#Can't think of a better way to do this :/
	cannon_bullet = bullet.instantiate()
	cannon_bullet.position = barrel.global_position
	cannon_bullet.transform.basis = barrel.global_transform.basis
	cannon_bullet.position = barrel.global_position
	cannon_bullet.transform.basis = barrel.global_transform.basis
	get_parent().add_child(cannon_bullet)
	print("pow")
