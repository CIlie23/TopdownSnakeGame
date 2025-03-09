extends CharacterBody3D

# https://www.youtube.com/watch?v=qg2kzZVe2RI

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../Player"
#@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@export var target_player: CharacterBody3D

var state = IDLE
var SPEED = 0.1
var target = null

var orbit_radius: float = 5.0  # Distance from the player
var orbit_speed: float = 0.03  # Rotation speed
var orbit_offset: Vector3 = Vector3.ZERO # Stores the initial offset

var bullet = load("res://scenes/enemies/rifle_robot/bullet.tscn")
var instance

enum{
	IDLE,
	ATTACK,
	CHASE,
	RETREAT
}

func _ready() -> void:
	orbit_offset = Vector3(orbit_radius, 2, 0) 
	
func _process(delta: float) -> void:
	match state:
		IDLE:
			animation.play("CharacterArmature|Idle")
		ATTACK:
			animation.play("CharacterArmature|Shoot")
		CHASE:
			animation.play("CharacterArmature|Walk")
		RETREAT:
			animation.play("CharacterArmature|Walk")


func _physics_process(delta: float) -> void:
	#if player:
	var target_position = player.position + orbit_offset
	position = position.lerp(target_position, orbit_speed)# Smoothly move towards target position
	look_at(target_position)
	rotate_y(deg_to_rad(180)) 
	move_and_slide()
	
	#rotation = Vector3(0, rotation.y, 0) # So that the model doesn't look up or down while the player is jumping

#----------------------------------------------------------------------------
# Some movement logic
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Detection
#----------------------------------------------------------------------------
func _on_detecting_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") and state == IDLE:
		target = body
		state = ATTACK
		print(body.name + "Detected")

#----------------------------------------------------------------------------
# Chase
#----------------------------------------------------------------------------
func _on_chase_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		target = null
		state = IDLE
		print(body.name + "Lost")
		pass 


#----------------------------------------------------------------------------
# Attack
#----------------------------------------------------------------------------
func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
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
