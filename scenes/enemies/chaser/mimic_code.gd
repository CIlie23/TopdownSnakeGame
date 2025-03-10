extends CharacterBody3D #Code for the mimic enemy

#----------------------------------------------------------------------------
# Known issues rn:
# Game crashes after player leaves the chase circle
# Enemy still chases after death
#----------------------------------------------------------------------------


@onready var sight: CollisionShape3D = $DetectArea/Sight
@onready var animations: AnimationPlayer = $Animations
@onready var skeleton: Skeleton3D = %GeneralSkeleton


@onready var idle_timer: Timer = $IdleTimer
@onready var wander_timer: Timer = $WanderTimer
@onready var despawn: Timer = $Despawn

@onready var detect_area: Area3D = $DetectArea
@onready var chase_range: Area3D = $ChaseRange
@onready var attack_range: Area3D = $AttackRange

@export var blend_speed = 1000

@onready var XPORB = preload("res://scenes/enemies/xporb.tscn")
var state = IDLE
var wander_directon: Vector3
var target = null

const MOVE_SPEED: float = 5.0
const ATTACK_RANGE: float = 2.5

enum {
	IDLE,
	PATROL,
	ALERT,
	CHASE,
	ATTACK,
	DEAD,
}

func _ready():
	idle_timer.start()
	#pass
	#animations.play("mimicAnimations/floor claw")
	#velocity = Vector3.ZERO
	
#func _on_detect_area_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Player"):
		##target = null
		#state = CHASE
		##print(body.name + "Lost")
		#pass 
		
#----------------------------------------------------------------------------
# Player is detected
#----------------------------------------------------------------------------
func _on_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and state == IDLE:
		idle_timer.stop()
		target = body
		state = ALERT
		await animations.animation_finished
		state = CHASE
		print(body.name + "Detected")
		#pass 
		
func _physics_process(delta):
	if target: #if the target is in range
		look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(180)) #turns model 180 degrees cause for some reason it's fillped?
		#velocity = position.direction_to(target.position) * MOVE_SPEED
	else:
		velocity = Vector3.ZERO  # Ensure no unintended movement
	velocity = velocity.limit_length(MOVE_SPEED) 
	
	move_and_slide()

#----------------------------------------------------------------------------
# Attack stuff
#----------------------------------------------------------------------------
func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Can attack")
		state = ATTACK
		velocity = Vector3.ZERO

func _on_attack_range_body_exited(body: Node3D) -> void:
	print("Can't attack")
	state = CHASE

func _target_hit():
	#if global_position.distance_to(target.global_position) < ATTACK_RANGE * 1.8:
		#var dir = global_position.distance_to(target.global_position)
	print("Hit")

#----------------------------------------------------------------------------
# Going back to idle
#----------------------------------------------------------------------------
func _on_chase_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		idle_timer.start()
		target = null
		state = IDLE
		print(body.name + "Lost")
		pass 

#func _target_in_range():
	#return global_position.distance_to(target.global_position) < ATTACK_RANGE

#----------------------------------------------------------------------------
# Handles all the states the enemy can be in
#----------------------------------------------------------------------------
func _process(delta):
	#random_direction()
	#if state == IDLE:
		#print("test")
		#idle_timer.start()
		
	if Input.is_action_pressed("killAll"):
		state = DEAD
	match state:
		IDLE:
			animations.play("memecAnimations/idle")
		PATROL:
			animations.play("memecAnimations/floor crawl")
			velocity = wander_directon * MOVE_SPEED
			move_and_slide()
		ALERT:
			animations.play("memecAnimations/screaming")
			#animation_tree.set("parameters/idle_scream_blend/blend_amount", 1)
			look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(180))
		CHASE:
			animations.play("memecAnimations/running")
			#animation_tree.set("parameters/scream_run_blend/blend_amount", 1)
			velocity = position.direction_to(target.position) * MOVE_SPEED
		ATTACK:
			#animation_tree.set("parameters/run_claw_blend/blend_amount", 1)
			animations.play("memecAnimations/claw")
			#animation_tree.set("parameters/conditions/attack", _target_in_range())
		DEAD:
			$CollisionShape3D.disabled = true
			print("dead")
			spawn_xp_orb()
			target = null
			skeleton.physical_bones_start_simulation()
			set_process(false)
			despawn.start()

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

func spawn_xp_orb():
	var xp_orb = XPORB.instantiate()
	xp_orb.global_position = global_position
	# Reparent to the world so it doesn't get deleted
	#get_parent().add_child(xp_orb) 
	get_tree().get_root().add_child(xp_orb)
	  # Spawn at enemy's last position
	print("XP orb spawned at:", xp_orb.global_position)
