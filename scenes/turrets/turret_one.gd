extends Node3D

#----------------------------------------------------------------------------
# Known issue: turret shoots when i colide with raycast
#----------------------------------------------------------------------------

@onready var head: MeshInstance3D = $turret_single/turret
@onready var turret_anim: AnimationPlayer = $AnimationPlayer

var target = null
var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var turret_bullet
#var right_bullet
var can_shoot = true 
@onready var left_barrel: RayCast3D = $turret_single/turret/LeftBarrel
@onready var right_barrel: RayCast3D = $turret_single/turret/RightBarrel

@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	print("Script Loaded!")

func _process(delta: float) -> void:
	if left_barrel.is_colliding() and right_barrel.is_colliding() and can_shoot:
		shoot_timer.start()
		can_shoot = false
	rotate_towards_target()

#----------------------------------------------------------------------------
# Turret Detecting
#----------------------------------------------------------------------------
func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"): #checking if the raycast is coliding so it doesn't shoot at random
		#head.look_at(target.global_transform.origin, Vector3.UP)
		target = body
		can_shoot = true
		print(body.name + " Detected")
		#if rifle_barrel.is_colliding():
			#print("hello fella")
			

func _on_detection_area_body_exited(body: Node3D) -> void:
	target = null
	shoot_timer.stop()
	print(body.name + " Lost :(")

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	turret_anim.play("shoot")
	_spawn_bullet(left_barrel)
	_spawn_bullet(right_barrel)
	
func _spawn_bullet(barrel: Node3D) -> void:
	turret_bullet = bullet.instantiate()
	turret_bullet.position = barrel.global_position
	turret_bullet.transform.basis = barrel.global_transform.basis
	get_parent().add_child(turret_bullet)
	#eeprint("pew")
#----------------------------------------------------------------------------
# Turret Rotation
#----------------------------------------------------------------------------
func rotate_towards_target():
	if target == null:
		pass
	else:
		head.look_at(target.global_transform.origin, Vector3.UP)
		head.rotate_y(deg_to_rad(180))
	
	#var target_position = target.global_transform.origind
	#var head_position = head.global_transform.origin
	
