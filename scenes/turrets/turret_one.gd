extends Node3D

#----------------------------------------------------------------------------
# Known issue: turret shoots when i colide with raycast
#----------------------------------------------------------------------------

@onready var head: MeshInstance3D = $turret_single/turret
@onready var turret_anim: AnimationPlayer = $AnimationPlayer

var target = null
var bullet = load("res://scenes/turrets/turretBullet.tscn")

#var right_bullet
var can_shoot = true 
@onready var left_barrel: RayCast3D = $turret_single/turret/LeftBarrel
@onready var right_barrel: RayCast3D = $turret_single/turret/RightBarrel

@onready var shoot_timer: Timer = $ShootTimer

#func _ready() -> void:
	#set_process(false)

func _process(delta: float) -> void:
	if target and can_shoot: #and left_barrel.is_colliding() and right_barrel.is_colliding() and 
		if target.state == target.DEAD:
			clear_target()
			return
		shoot_timer.start()
		can_shoot = false
		rotate_towards_target()

func clear_target():
	set_process(false)
	target = null
	shoot_timer.stop()
#----------------------------------------------------------------------------
# Turret Detecting
#----------------------------------------------------------------------------
func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"): #checking if the raycast is coliding so it doesn't shoot at random
		#head.look_at(target.global_transform.origin, Vector3.UP)
		set_process(true)
		target = body
		can_shoot = true
		#print(body.name + " Detected")
		#if rifle_barrel.is_colliding():
			#print("hello fella")
			
func _on_detection_area_body_exited(body: Node3D) -> void:
	set_process(false)
	target = null
	shoot_timer.stop()
	#print(body.name + " Lost :(")

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	turret_anim.play("shoot")
	_spawn_bullet(left_barrel)
	_spawn_bullet(right_barrel)
	
func _spawn_bullet(barrel: Node3D) -> void:
	var turret_bullet  = bullet.instantiate()
	turret_bullet.global_transform = barrel.global_transform
	#turret_bullet.position = barrel.global_position
	#turret_bullet.transform.basis = barrel.global_transform.basis
	get_tree().current_scene.add_child(turret_bullet)
	#eeprint("pew")
#----------------------------------------------------------------------------
# Turret Rotation
#----------------------------------------------------------------------------
func rotate_towards_target():
	if target:
		head.look_at(target.global_transform.origin, Vector3.UP)
		head.rotate_y(deg_to_rad(180))

	
	#var target_position = target.global_transform.origind
	#var head_position = head.global_transform.origin
	
