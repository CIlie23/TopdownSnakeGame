extends CharacterBody3D

class_name PlayerStuff

#--------------------------MOVEMENT LOGIC--------------------------------
@export var grid_size: float = 1.1 
var move_duration: float = 0.11  # How long each move takes
#@onready var snake_head: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var snake_head: Node3D = $CollisionShape3D/Player

var direction = Vector3(0, 0, 0)  # Default movement direction
var last_used_direction = direction
var snake_bodies = []
var tail_piece = preload("res://scenes/world/snake_segment.tscn")

var is_moving = false  # Prevents input spam while moving

#------------------------------BULLETS--------------------------------
@onready var barrel: RayCast3D = $CollisionShape3D/Player/Rifle
const PLASMA_BALL = preload("res://scenes/abilities/assets/plasma_ball.tscn")
var CANNON_BALL = preload("res://scenes/turrets/cannon_ball.tscn")
var ball

#-------------------------PLAYER STATS IMPORTS------------------------
var playerStats = preload("res://scripts/player/player_stats.tres")
#var skilltree: SkillAtribute
@onready var mana_regen: Timer = $ManaRegen
@onready var speed_particles: GPUParticles3D = $SpeedParticles

signal player_hit
signal player_dead

func hit():
	playerStats.playerHealth -= 10
	#print(playerStats.playerHealth, " Health")
	#print("damaged")
	emit_signal("player_hit")

func bulletHit():
	playerStats.playerHealth -= 0.5
	#print(playerStats.playerHealth, " Health")
	#print("damaged")
	emit_signal("player_hit")

func _ready():
	#gpt failsafe
	global_position = Vector3(0, 0, 0)
	print("Player ready")
	position = position.snapped(Vector3.ONE * grid_size)
	last_used_direction = Vector3(0, 0, -1)
	snake_bodies.clear()
	is_moving = false

	position = position.snapped(Vector3.ONE * grid_size)


func _process(_delta):

	if playerStats.playerHealth <= 0:
		emit_signal("player_dead")
		#print("Player is dead")
	handle_input()
	#if Input.is_action_just_pressed("extend_snake"):
		#extend()

func handle_input():
	if is_moving:
		return  # Ignore input while moving

	var new_direction = direction
 	
	# We prevent reversing (e.g., moving right and immediately moving left) by checking last_used_direction.
	if Input.is_action_pressed("game_up") and last_used_direction != Vector3(0, 0, 1):
		new_direction = Vector3(0, 0, -1)
	elif Input.is_action_pressed("game_down") and last_used_direction != Vector3(0, 0, -1):
		new_direction = Vector3(0, 0, 1)
	elif Input.is_action_pressed("game_left") and last_used_direction != Vector3(1, 0, 0):
		new_direction = Vector3(-1, 0, 0)
	elif Input.is_action_pressed("game_right") and last_used_direction != Vector3(-1, 0, 0):
		new_direction = Vector3(1, 0, 0)

	if new_direction != direction:
		# Rotate smoothly towards the new direction
		rotate_towards(new_direction)
		
	direction = new_direction

	move_snake()

#func rotate_towards(new_direction: Vector3):
	#var target_position = position + new_direction
	#target_position.y = snake_head.global_transform.origin.y  # Keep Y-level fixed
	#snake_head.look_at(target_position, Vector3.UP)
	#snake_head.rotate_y(PI)
func rotate_towards(new_direction: Vector3):
	var target_position = position + new_direction
	if snake_head.global_transform.origin.is_equal_approx(target_position):
		return  # Avoid look_at on same position, which causes NaNs
	
	target_position.y = snake_head.global_transform.origin.y
	snake_head.look_at(target_position, Vector3.UP)

	# Optional: avoid this if you aren't sure why it's needed
	snake_head.rotate_y(PI)
	
func move_snake():
	is_moving = true
	var target_position = position + direction * grid_size

	# Tween for smooth movement
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, move_duration) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)

	# Move snake bodies
	var old_position = position
	for body in snake_bodies:
		var temp_position = body.position
		body.position = old_position
		old_position = temp_position

	# After move completes, allow new input
	tween.finished.connect(_on_tween_completed)

func _on_tween_completed():
	is_moving = false
	last_used_direction = direction  # Lock in movement to prevent reversing

func extend():
	var new_body = tail_piece.instantiate()

	if snake_bodies.size() > 0:
		new_body.position = snake_bodies[-1].position - last_used_direction * grid_size
	else:
		new_body.position = position - last_used_direction * grid_size

	snake_bodies.append(new_body)
	get_tree().current_scene.add_child(new_body)
	
	show_weapon_popup_for_segment(new_body)

func show_weapon_popup_for_segment(segment: Node3D):
	var popup = preload("res://scenes/UI/turret_chooser.tscn").instantiate()
	get_tree().current_scene.add_child(popup)

	popup.weapon_selected.connect(func(weapon_type):
		attach_weapon_to_segment(segment, weapon_type)
	)

func attach_weapon_to_segment(segment: Node3D, weapon_type: String):
	var weapon_scene: PackedScene

	match weapon_type:
		"turretOne":
			weapon_scene = preload("res://scenes/turrets/turret_one.tscn")
		"doubleTurret":
			weapon_scene = preload("res://scenes/turrets/double_turret.tscn")
		"cannon":
			weapon_scene = preload("res://scenes/turrets/cannon_small.tscn")
		"machineGun":
			weapon_scene = preload("res://scenes/turrets/updated_machinegun.tscn")

	var weapon_instance = weapon_scene.instantiate()

	# Attach the weapon to the segment
	segment.add_child(weapon_instance)

	# Position it slightly above the cube so it's visible
	weapon_instance.position = Vector3(0, 0.3, 0) 


#func collect(item): #connected to inventory.gd
	#inv.insert(item)

#----------------------------------------------------------------------------
# ABILITIESSSSSSSS
#---------------------------------------------------------------------------- 

func shoot_plasmaball():
	#print(playerStats.mana)
	ball = PLASMA_BALL.instantiate()
	ball.position = barrel.global_position
	ball.transform.basis = barrel.global_transform.basis
	ball.position = barrel.global_position
	ball.transform.basis = barrel.global_transform.basis
	get_parent().add_child(ball)

func _on_mana_regen_timeout() -> void:
	if playerStats.mana < playerStats.maxMana:
		playerStats.mana += playerStats.manaRegen
		playerStats.mana = min(playerStats.mana, playerStats.maxMana)

func _on_health_regen_timeout() -> void:
	if playerStats.playerHealth < playerStats.max_playerHealth:
		playerStats.playerHealth  += playerStats.healthRegen
		playerStats.playerHealth  = min(playerStats.playerHealth, playerStats.max_playerHealth)

#func _spawn_swarm(player: Node3D):
	#if drones.size() < max_drones:
		#for i in range(max_drones):
			#var angle = (PI * 2 / max_drones) * i  # Spread them evenly in a circle
			#var spawn_position = player.position + Vector3(cos(angle), 0, sin(angle)) * spawn_radius
			#
			#var drone = drone_scene.instantiate()
			#drone.position = spawn_position
			#drone.set_owner(player)  # Set the player as the owner
			#drone.player = player  # Assign player reference for AI behavior
#
			#player.get_parent().add_child(drone)  # Spawn in world
			#drones.append(drone)
