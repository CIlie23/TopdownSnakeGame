extends CharacterBody3D

class_name gunnerRobot
#----------------------------------------------------------------------------
# 
# 
# 
#----------------------------------------------------------------------------
@export var gunnerHEALTH: int = 100

var friendly_drone_damage = friendlyDrone.new().droneDAMAGE
@onready var healthbar_3d: ProgressBar = $SubViewport/Healthbar3D

@export var rotation_speed: float = 2 # Speed of rotation in degrees per second
@onready var animations: AnimationPlayer = $Animations
@onready var vfx_fire: Node3D = $"XRKArmature/GeneralSkeleton/Physical Bone Chest/vfx_Fire"

@onready var idle_timer: Timer = $IdleTimer
@onready var wander_timer: Timer = $WanderTimer
@onready var skeleton: Skeleton3D = %GeneralSkeleton
@onready var shoot_timer: Timer = $ShootTimer
@onready var raycast: RayCast3D = $RayCast3D
#@onready var eyes: Node3D = $Eyes

@onready var pew_pew_particles: GPUParticles3D = $XRKArmature/GeneralSkeleton/BoneAttachment3D/rifle/pewPewParticles
@onready var despawn: Timer = $Despawn

@onready var rifle_barrel: Node3D = $XRKArmature/GeneralSkeleton/BoneAttachment3D/rifle/RayCast3D
var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance

var xp_orb_scene = preload("res://scenes/enemies/xporb.tscn")

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
	healthbar_3d.value = gunnerHEALTH
	idle_timer.start()
	
#----------------------------------------------------------------------------
# Player is detected
#----------------------------------------------------------------------------

func takeDamage(amount: int, killer_type: String) -> void:
	healthbar_3d.value = gunnerHEALTH
	gunnerHEALTH -= amount
	
	if gunnerHEALTH <= 50:
		vfx_fire.visible = true
	
	if gunnerHEALTH <= 0:# and state != "DEAD":
		die(killer_type)
		
# I could have probably passed a few vars for damage inside the function but uh fk it we ball
#func plasmaBallHit():
	##print(plasma_ball_damage, " damage")
	##print(gunnerHEALTH, " gunner health")
	#gunnerHEALTH -= plasma_ball_damage
	
func hit():
	#print(friendly_drone_damage, " damage")
	#print(gunnerHEALTH, " gunner health")
	gunnerHEALTH -= friendly_drone_damage
	
#func lightningHit():
	#print(lightning_damage, " damage")
	#print(gunnerHEALTH, " gunner health")
	#gunnerHEALTH -= lightning_damage
#----------------------------------------------------------------------------
func _on_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and state == IDLE:
		var closest = find_closest_target()
		if closest:
			idle_timer.stop()
			target = body
			state = ATTACK
			shoot_timer.start()
		#print(body.name + "Detected")

func _physics_process(delta):
	if target:
		var target_pos = target.global_transform.origin
		var self_pos = global_transform.origin
		var dir = target_pos - self_pos

		if dir.length_squared() > 0.0001:
			look_at(target_pos, Vector3.UP)
			rotate_y(deg_to_rad(180))  # Adjust for model rotation
	else:
		velocity = Vector3.ZERO

	velocity = velocity.limit_length(MOVE_SPEED)
	move_and_slide()

#----------------------------------------------------------------------------
# Attack stuff
#----------------------------------------------------------------------------

func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var closest = find_closest_target()
		if closest and closest != target:
			idle_timer.stop()
			shoot_timer.start()
			target = body
			state = ATTACK
		#velocity = position.direction_to(target.position) * AIM_MOVE_SPEED

func _on_attack_range_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Player"):
		##print("Can't attack") 
		#state = CHASE
		#shoot_timer.stop()
	if body == target:
		target = find_closest_target()			
		if target:
			state = CHASE
		else:
			state = IDLE
			shoot_timer.stop()

func _on_shoot_timer_timeout() -> void:
	#print("pew")
	#pew_pew_particles.emitting = true
	instance = bullet.instantiate()
	instance.position = rifle_barrel.global_position
	instance.transform.basis = rifle_barrel.global_transform.basis
	get_parent().add_child(instance)
	
func _target_hit():

	print("Hit")
#----------------------------------------------------------------------------
# Going back to idle
#----------------------------------------------------------------------------

func _on_chase_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and state != DEAD:
		idle_timer.call_deferred("start")

		shoot_timer.stop()
		target = null
		state = IDLE
		#print(body.name + "Lost") 
		pass 
	
#----------------------------------------------------------------------------
# Handles all the states the enemy can be in
#----------------------------------------------------------------------------
func _process(delta: float) -> void:
	#if gunnerHEALTH <= 50:
		#vfx_fire.visible = true
		#
	#if gunnerHEALTH <= 0 and state != DEAD:
		#print("GUNNER dead")
		#die()
		
	if Input.is_action_pressed("killAll"):
		state = DEAD
	match state:
		IDLE:
			animations.play("GunnerAnimations/idle")
		PATROL:
			animations.play("GunnerAnimations/walk forward")
			velocity = wander_directon * MOVE_SPEED
			move_and_slide()
		ALERT:
			#print("Im alerted")
			animations.play("GunnerAnimations/run forward")
			#eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(180))
			#rotate_y(deg_to_rad(eyes.rotation.y * rotation_speed))
		CHASE:
			animations.play("GunnerAnimations/run forward")
			velocity = position.direction_to(target.position) * MOVE_SPEED
		ATTACK:
			animations.play("GunnerAnimations/walk forward aim")
			velocity = position.direction_to(target.position) * AIM_MOVE_SPEED
			#svelocity = Vector3.ZERO
		DEAD:
			pass

func find_closest_target():
	var all_players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
 
	if (all_players.size() > 0):
		closest_player = all_players[0]
		for player in all_players:
			var distance_to_this_player = global_position.distance_squared_to(player.global_position)
			var distance_to_closest_player = global_position.distance_squared_to(closest_player.global_position)
			if (distance_to_this_player < distance_to_closest_player):
				closest_player = player
 
	return closest_player
#----------------------------------------------------------------------------
# Wander timers
#----------------------------------------------------------------------------
func random_direction():
	wander_directon = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))

func _on_idle_timer_timeout() -> void:
	random_direction()
	#eyes.look_at(wander_directon)
	#print("I am now wandering")
	state = PATROL
	velocity = wander_directon * MOVE_SPEED
	
	wander_timer.start()

func _on_wander_timer_timeout() -> void:
	#print("I am now chilling")
	state = IDLE
	velocity = Vector3.ZERO
	
	idle_timer.start()

func _on_despawn_timeout() -> void:
	queue_free()

func spawn_xp_orb():
	var orb_instance = xp_orb_scene.instantiate()
	get_tree().current_scene.add_child(orb_instance)
	orb_instance.global_transform.origin = global_transform.origin

func die(killer_type: String):
	if state == DEAD:
		return
	healthbar_3d.visible = false
	Global.report_enemy_killed_by(killer_type)
	Global.total_enemies -= 1
	Global.total_enemy_kills += 1
	#print("GUNNER dead")
	state = DEAD
	spawn_xp_orb()
	$Hitbox.call_deferred("set_disabled", true)
	target = null
	shoot_timer.stop()
	idle_timer.stop()
	
	# Start death effects
	skeleton.physical_bones_start_simulation()
	set_process(false)
	despawn.start()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	healthbar_3d.visible = true
	animations.play("GunnerAnimations/idle")
	#print("animations playing")
	#set_process(false)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	animations.stop()
	#print("animations stopped")
	healthbar_3d.visible = false
