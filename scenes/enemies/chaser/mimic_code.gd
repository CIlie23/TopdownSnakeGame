extends CharacterBody3D #Code for the mimic enemy

#----------------------------------------------------------------------------
#
#----------------------------------------------------------------------------

@export var chaserHEALTH: int = 120

var friendly_drone_damage = friendlyDrone.new().droneDAMAGE
#var plasma_ball_damage = plasmaBall.new().plasmaBallDAMAGE
#var lightning_damage = lightningScene.new().lightningDamage

@onready var sight: CollisionShape3D = $DetectArea/Sight
@onready var animations: AnimationPlayer = $Animations
@onready var skeleton: Skeleton3D = %GeneralSkeleton
@onready var vfx_fire: Node3D = $"SK_DLC_Old_Endo/GeneralSkeleton/Physical Bone Spine/vfx_Fire"


@onready var idle_timer: Timer = $IdleTimer
@onready var wander_timer: Timer = $WanderTimer
@onready var despawn: Timer = $Despawn

@onready var detect_area: Area3D = $DetectArea
@onready var chase_range: Area3D = $ChaseRange
@onready var attack_range: Area3D = $AttackRange

var xp_orb_scene = preload("res://scenes/enemies/xporb.tscn")

@export var blend_speed = 1000
#@export var enemy_health: int


var state = IDLE
var wander_directon: Vector3
var target = null

var player = null
#@export var player_path: NodePath
@onready var player_path = get_node("/root/Spacial/Player")
const MOVE_SPEED: float = 7.0
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

#----------------------------------------------------------------------------
# Player is detected
#----------------------------------------------------------------------------

func takeDamage(amount: int, killer_type: String) -> void:
	chaserHEALTH -= amount
	
	if chaserHEALTH <= 50:
		vfx_fire.visible = true
	
	if chaserHEALTH <= 0:# and state != "DEAD":
		die(killer_type)
	
#func plasmaBallHit(amount: int, killer_type: String) -> void:
	#chaserHEALTH -= plasma_ball_damage

func hit():
	chaserHEALTH -= friendly_drone_damage

#func lightningHit():
	#chaserHEALTH -= lightning_damage
	
func _on_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and state == IDLE:
		var closest = find_closest_target()
		if closest:
			idle_timer.stop()
			target = body
			state = ALERT
			await animations.animation_finished
			state = CHASE
			#print(body.name + "Detected")
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
		#print("Can attack")
		state = ATTACK
		velocity = Vector3.ZERO

func _on_attack_range_body_exited(body: Node3D) -> void:
	if body == target:
		target = find_closest_target()			
		if target:
			state = CHASE
		else:
			state = IDLE

func _target_hit():
	player_path.hit()
	#print("Hit")

#----------------------------------------------------------------------------
# Going back to idle
#----------------------------------------------------------------------------
func _on_chase_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and state != DEAD:
		idle_timer.start()
		target = null
		state = IDLE
		#print(body.name + "Lost")
#func _target_in_range():
	#return global_position.distance_to(target.global_position) < ATTACK_RANGE

#----------------------------------------------------------------------------
# Handles all the states the enemy can be in
#----------------------------------------------------------------------------
func _process(delta):		
	#if chaserHEALTH <= 50:
		#vfx_fire.visible = true
		
	#if chaserHEALTH <= 0 and state != DEAD:
		#die()
		
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
			# still crashes
			velocity = position.direction_to(target.position) * MOVE_SPEED
		ATTACK:
			#animation_tree.set("parameters/run_claw_blend/blend_amount", 1)
			animations.play("memecAnimations/claw")
			#animation_tree.set("parameters/conditions/attack", _target_in_range())
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
	#look_at(wander_directon)
	look_at(global_position + wander_directon, Vector3.UP)
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
	Global.report_enemy_killed_by(killer_type)
	Global.total_enemies -= 1
	Global.total_enemy_kills += 1
	print(Global.total_enemies, " enemies left")
	state = DEAD
	spawn_xp_orb()
	$CollisionShape3D.disabled = true
	target = null
	idle_timer.stop()
	
	skeleton.physical_bones_start_simulation()
	despawn.start()
	set_process(false)


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	animations.stop()
	#set_process(false)
	#print("anims stopped")


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	#set_process(true)
	animations.play("memecAnimations/idle")
