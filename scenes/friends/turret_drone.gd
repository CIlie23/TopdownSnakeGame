extends CharacterBody3D

# https://www.youtube.com/watch?v=qg2kzZVe2RI

@onready var animation: AnimationPlayer = $AnimationPlayer
#@onready var player: CharacterBody3D = $"../Player"
#@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@export var target_player = preload("res://scenes/world/player.tscn")

var state = FOLLOW_PLAYER
var target = null
var player = null

var follow_distance: float = 5.5  # Distance from the player
var speed: float = 7.5  # Rotation speed
var orbit_offset: Vector3 = Vector3.ZERO # Stores the initial offset

var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance

enum{
	FOLLOW_PLAYER,
	CHASE_ENEMY,
	RETURN_TO_PLAYER,
}

func _ready() -> void:
	player = get_node("/root/Spacial/Player")
	#orbit_offset = Vector3(orbit_radius, 2, 0) 
	
func _physics_process(delta: float) -> void:
	match state:
		FOLLOW_PLAYER:
			follow_player(delta)
		CHASE_ENEMY:
			chase_enemy(delta)
		RETURN_TO_PLAYER:
			return_to_player(delta)
	move_and_slide()  

	#rotation = Vector3(0, rotation.y, 0) # So that the model doesn't look up or down while the player is jumping

#----------------------------------------------------------------------------
# Some movement logic
#----------------------------------------------------------------------------
func follow_player(delta):
	animation.play("CharacterArmature|Idle")
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed

		look_at(player.global_transform.origin)
		rotate_y(deg_to_rad(180))

func chase_enemy(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed

		look_at(target.global_transform.origin)
		animation.play("CharacterArmature|Shoot")
	else:
		state = RETURN_TO_PLAYER

func return_to_player(delta):
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed

		look_at(player.global_transform.origin)
		animation.play("CharacterArmature|Walk")

		# Optional: auto switch back if close enough
		if global_transform.origin.distance_to(player.global_transform.origin) < 2.0:
			state = FOLLOW_PLAYER

#-----------------------------------------
# Detection
#----------------------------------------------------------------------------
func _on_detecting_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") and state == FOLLOW_PLAYER:
		target = body
		state = CHASE_ENEMY
		look_at(target.position) 
		print(body.name + "Detected")

#----------------------------------------------------------------------------
# Chase
#----------------------------------------------------------------------------
func _on_chase_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		target = null
		state = FOLLOW_PLAYER
		print(body.name + "Lost")
		pass 

#----------------------------------------------------------------------------
# Attack
#----------------------------------------------------------------------------
func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		print("Can attack")
		state = CHASE_ENEMY
		#velocity = Vector3.ZERO

func _on_attack_range_body_exited(body: Node3D) -> void:
	print("Can't attack")
	state = RETURN_TO_PLAYER
	look_at(player.global_transform.origin)

func _target_hit():
	#if global_position.distance_to(target.global_position) < ATTACK_RANGE * 1.8:
		#var dir = global_position.distance_to(target.global_position)
	print("Hit")
