extends Node3D

#@onready var barrel: RayCast3D = $turret_double/turret/BarrelRightOne
@onready var shoot_timer: Timer = $ShootTimer
@onready var turret_head: MeshInstance3D = $turret_double/turret
#@onready var turret_head: MeshInstance3D = $turret_double
@onready var turret_anim: AnimationPlayer = $AnimationPlayer

@onready var barrel_right_one: RayCast3D = $turret_double/turret/BarrelRightOne
@onready var barrel_right_two: RayCast3D = $turret_double/turret/BarrelRightTwo
@onready var barrel_left_one: RayCast3D = $turret_double/turret/BarrelLeftOne
@onready var barrel_left_two: RayCast3D = $turret_double/turret/BarrelLeftTwo

var target = null
var bullet = load("res://scenes/turrets/turretBullet.tscn")
var cannon_bullet
var can_shoot = true 

func _ready() -> void:
	print("Cannon Loaded!")

func _process(delta: float) -> void:
	if barrel_left_one.is_colliding() and can_shoot:
		shoot_timer.start()
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
	if body.is_in_group("Enemy"): #checking if the raycast is coliding so it doesn't shoot at random
		#head.look_at(target.global_transform.origin, Vector3.UP)
		target = body
		can_shoot = true
		print(body.name + " Detected")

func _on_area_3d_body_exited(body: Node3D) -> void:
	target = null
	shoot_timer.stop()
	print(body.name + " Lost :(")

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	turret_anim.play("shoot")
	_spawn_bullet(barrel_left_one)
	_spawn_bullet(barrel_left_two)
	_spawn_bullet(barrel_right_one)
	_spawn_bullet(barrel_right_two)

func _spawn_bullet(barrel: Node3D) -> void:
	cannon_bullet = bullet.instantiate()
	cannon_bullet.position = barrel.global_position
	cannon_bullet.transform.basis = barrel.global_transform.basis
	get_parent().add_child(cannon_bullet)
	#print("pew")
