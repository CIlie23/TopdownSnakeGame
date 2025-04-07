extends CharacterBody3D

@export var smallDroneHealth: int = 130
var friendly_drone_damage = friendlyDrone.new().droneDAMAGE
@onready var healthbar_3d: ProgressBar = $SubViewport/Healthbar3D


@onready var skeleton: Skeleton3D = $Drone1_Armature/Skeleton3D
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var vfx_fire: Node3D = $"Drone1_Armature/Skeleton3D/Physical Bone Body/vfx_Fire"

@onready var idle_timer: Timer = $IdleTimer

@onready var wander_timer: Timer = $WanderTimer
@onready var despawn: Timer = $Despawn
@onready var shoot_timer: Timer = $ShootTimer

@onready var rifle_barrel: Node3D = $"Drone1_Armature/Skeleton3D/Physical Bone Body/RayCast3D"

var xp_orb_scene = preload("res://scenes/enemies/xporb.tscn")

var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance
var can_look: bool = true
var state = IDLE
var target = null
var wander_directon: Vector3

var MOVE_SPEED: float = 5.0
var AIM_MOVE_SPEED: float = 3.5

const TARGET_SWITCH_THRESHOLD = 30.0

enum {
	IDLE,
	PATROL,
	ALERT,
	CHASE,
	ATTACK,
	DEAD,
}

func _ready() -> void:
	healthbar_3d.value = smallDroneHealth
	idle_timer.start()

func _process(delta: float) -> void:
	#if smallDroneHealth <= 50:
		#vfx_fire.visible = true	
	#if smallDroneHealth <= 0 and state != DEAD:
		#die()
		
	match state:
		IDLE:
			animations.play("idle")
		PATROL:
			animations.play("walk")
			velocity = wander_directon * MOVE_SPEED
			move_and_slide()
		ALERT:
			animations.play("walk")
			#look_at(target.global_transform.origin, Vector3.UP)
			#rotate_y(deg_to_rad(180))
			#rotate_y(deg_to_rad(eyes.rotation.y * rotation_speed))
		CHASE:
			animations.play("walk")
			velocity = position.direction_to(target.position) * MOVE_SPEED
		ATTACK:
			#print("Attacking")
			animations.play("walk")
			velocity = position.direction_to(target.position) * AIM_MOVE_SPEED
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
# Player is detected
#----------------------------------------------------------------------------
func takeDamage(amount: int, killer_type: String) -> void:
	healthbar_3d.value = smallDroneHealth
	smallDroneHealth -= amount
	
	if smallDroneHealth <= 50:
		vfx_fire.visible = true
	
	if smallDroneHealth <= 0:# and state != "DEAD":
		die(killer_type)

#func plasmaBallHit():
	#smallDroneHealth -= plasma_ball_damage

func hit():
	smallDroneHealth -= friendly_drone_damage
		
#func lightningHit():
	#smallDroneHealth -= lightning_damage
	
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
	if state == DEAD:
		can_look = false
		velocity = Vector3.ZERO
		return

	if target and can_look:
		var target_pos = target.global_transform.origin
		var self_pos = global_transform.origin
		var dir = target_pos - self_pos

		if dir.length_squared() > 0.0001:
			look_at(target_pos, Vector3.UP)
	else:
		velocity = Vector3.ZERO  # Ensure no unintended movement

	velocity = velocity.limit_length(MOVE_SPEED)
	move_and_slide()

#----------------------------------------------------------------------------
# Attack stuff
#----------------------------------------------------------------------------
func _on_attack_area_body_entered(body: Node3D) -> void:
	if state == DEAD: return
	if body.is_in_group("Player") and state != DEAD:
		var closest = find_closest_target()
		if closest and closest != target:
			idle_timer.call_deferred("start")
			target = body
			state = ATTACK
			shoot_timer.start()

func _on_attack_area_body_exited(body: Node3D) -> void:
	if state == DEAD: return
	if body == target:
		target = find_closest_target()
		if target:
			state = CHASE
		else:
			state = IDLE
			shoot_timer.stop()
	#if body.is_in_group("Player"):
		##print("Can't attack") 
		#state = CHASE
		#shoot_timer.stop()

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
	if body.is_in_group("Player") and state != DEAD:
		#exclamation_mark.visible = false
		idle_timer.call_deferred("start")
		shoot_timer.stop()
		target = null
		state = IDLE
		#print(body.name + "Lost") 

#----------------------------------------------------------------------------
# Wander timers
#----------------------------------------------------------------------------
func random_direction():
	wander_directon = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))

func _on_idle_timer_timeout() -> void:
	random_direction()
	look_at(wander_directon)
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
	state = DEAD
	spawn_xp_orb()
	$Hitbox.call_deferred("set_disabled", true)
	target = null
	shoot_timer.stop()
	idle_timer.stop()
	
	skeleton.physical_bones_start_simulation()
	despawn.start()
	set_process(false)


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	animations.play("idle")
	healthbar_3d.visible = true
	#set_process(false)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	animations.stop()
	healthbar_3d.visible = false
	
