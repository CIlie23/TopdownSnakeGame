extends CharacterBody3D

@onready var skeleton: Skeleton3D = $Drone1_Armature/Skeleton3D
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var vfx_fire: Node3D = $"Drone1_Armature/Skeleton3D/Physical Bone Body/vfx_Fire"

@onready var idle_timer: Timer = $IdleTimer
@onready var wander_timer: Timer = $WanderTimer
@onready var despawn: Timer = $Despawn
@onready var exclamation_mark: Sprite3D = $ExclamationMark
@onready var shoot_timer: Timer = $ShootTimer

@onready var rifle_barrel: Node3D = $"Drone1_Armature/Skeleton3D/Physical Bone Body/RayCast3D"
var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance

var state = IDLE
var target = null
var wander_directon: Vector3

var MOVE_SPEED: float = 5.0
var AIM_MOVE_SPEED: float = 3.5
enum {
	IDLE,
	PATROL,
	ALERT,
	CHASE,
	ATTACK,
	DEAD,
}

func _ready() -> void:
	idle_timer.start()

func _process(delta: float) -> void:
	if Input.is_action_pressed("killAll"):
		state = DEAD
	match state:
		IDLE:
			animations.play("idle")
		PATROL:
			animations.play("walk")
			velocity = wander_directon * MOVE_SPEED
			move_and_slide()
		ALERT:
			#print("Im alerted")
			animations.play("walk")
			#eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(180))
			#rotate_y(deg_to_rad(eyes.rotation.y * rotation_speed))
		CHASE:
			animations.play("walk")
			velocity = position.direction_to(target.position) * MOVE_SPEED
		ATTACK:
			print("Attacking")
			animations.play("walk")
			velocity = position.direction_to(target.position) * AIM_MOVE_SPEED
			#eyes.look_at(target.global_transform.origin, Vector3.UP)
			#rotate_y(deg_to_rad(180))
			#rotate_y(deg_to_rad(eyes.rotation.y * rotation_speed))
		DEAD:
			target = null
			skeleton.physical_bones_start_simulation()
			#queue_free()
			set_process(false)
			#shoot_timer.stop()
			despawn.start()

#----------------------------------------------------------------------------
# Player is detected
#----------------------------------------------------------------------------
func _on_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and state == IDLE:
		exclamation_mark.visible = true
		idle_timer.stop()
		target = body
		#state = ALERT
		#await animations.animation_finished
		state = ATTACK
		shoot_timer.start()
		
		print(body.name + "Detected")

func _physics_process(delta):
	if target: #if the target is in range
		look_at(target.global_transform.origin, Vector3.UP)
		#rotate_y(deg_to_rad(180)) #turns model 180 degrees cause for some reason it's fillped?
		#velocity = position.direction_to(target.position) * MOVE_SPEED
		pass
	else:
		velocity = Vector3.ZERO  # Ensure no unintended movement
	velocity = velocity.limit_length(MOVE_SPEED) 
	
	move_and_slide()
#----------------------------------------------------------------------------
# Attack stuff
#----------------------------------------------------------------------------
func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#if body.is_in_group("Player"):
		print("Can attack")
		idle_timer.stop()
		shoot_timer.start()
		target = body
		state = ATTACK

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Can't attack") 
		state = CHASE
		shoot_timer.stop()

func _on_shoot_timer_timeout() -> void:
	instance = bullet.instantiate()
	instance.position = rifle_barrel.global_position
	instance.transform.basis = rifle_barrel.global_transform.basis
	get_parent().add_child(instance)

func _target_hit():
	print("hit")

#----------------------------------------------------------------------------
# Going back to idle
#----------------------------------------------------------------------------
func _on_chase_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		exclamation_mark.visible = false
		idle_timer.start()
		shoot_timer.stop()
		target = null
		state = IDLE
		print(body.name + "Lost") 

#----------------------------------------------------------------------------
# Wander timers
#----------------------------------------------------------------------------
func random_direction():
	wander_directon = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))

func _on_idle_timer_timeout() -> void:
	random_direction()
	look_at(wander_directon)
	print("I am now wandering")
	state = PATROL
	velocity = wander_directon * MOVE_SPEED

	wander_timer.start()

func _on_wander_timer_timeout() -> void:
	print("I am now chilling")
	state = IDLE
	velocity = Vector3.ZERO
	
	idle_timer.start()

func _on_despawn_timeout() -> void:
	queue_free()
