extends CharacterBody3D

@export var grid_size: float = 1.0  # Adjust this to match your scene's grid
var move_duration: float = 0.1  # How long each move takes
@onready var snake_head: MeshInstance3D = $CollisionShape3D/MeshInstance3D

@export var inv: Inv #inventory

#------------------------------BULLETS--------------------------------
@onready var barrel: RayCast3D = $CollisionShape3D/MeshInstance3D/DirArrow/Rifle
const PLASMA_BALL = preload("res://scenes/abilities/assets/plasma_ball.tscn")
var CANNON_BALL = preload("res://scenes/turrets/cannon_ball.tscn")
var ball

var playerStats = preload("res://scripts/player/player_stats_resource.tres")
var skilltree: SkillAtribute

var direction = Vector3(0, 0, 0)  # Default movement direction
var last_used_direction = direction
var snake_bodies = []
var tail_piece = preload("res://scenes/world/snake_segment.tscn")

var is_moving = false  # Prevents input spam while moving

func _ready():
	#print(move_duration)
	#print(playerStats.playerHealth, " health")
	#print(skilltree.healthBoost += 10)
	# Ensure position starts snapped to grid
	position = position.snapped(Vector3.ONE * grid_size)

func _process(_delta):
	handle_input()
	if Input.is_action_just_pressed("shoot"):
		_shoot_plasmaball()
	if Input.is_action_just_pressed("extend_snake"):
		extend()

func handle_input():
	if is_moving:
		return  # Ignore input while moving

	var new_direction = direction
 	
	# We prevent reversing (e.g., moving right and immediately moving left) by checking last_used_direction.
	if Input.is_action_pressed("game_up") and last_used_direction != Vector3(0, 0, 1):
		#snake_head.look_at(new_direction)
		new_direction = Vector3(0, 0, -1)
	elif Input.is_action_pressed("game_down") and last_used_direction != Vector3(0, 0, -1):
		#snake_head.look_at(new_direction)
		new_direction = Vector3(0, 0, 1)
	elif Input.is_action_pressed("game_left") and last_used_direction != Vector3(1, 0, 0):
		#snake_head.look_at(new_direction)
		new_direction = Vector3(-1, 0, 0)
	elif Input.is_action_pressed("game_right") and last_used_direction != Vector3(-1, 0, 0):
		#snake_head.look_at(new_direction)
		new_direction = Vector3(1, 0, 0)

	if new_direction != direction:
		# Rotate smoothly towards the new direction
		rotate_towards(new_direction)
		
	direction = new_direction

	move_snake()

func rotate_towards(new_direction: Vector3):
	var target_position = position + new_direction
	snake_head.look_at(target_position, Vector3.UP)  # Make the head look in the movement direction

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

func collect(item): #connected to inventory.gd
	inv.insert(item)

#----------------------------------------------------------------------------
# ABILITIESSSSSSSS
#---------------------------------------------------------------------------- 
func _shoot_plasmaball():
	ball = PLASMA_BALL.instantiate()
	ball.position = barrel.global_position
	ball.transform.basis = barrel.global_transform.basis
	ball.position = barrel.global_position
	ball.transform.basis = barrel.global_transform.basis
	get_parent().add_child(ball)

func _speed_up():
	$SpeedUPtimer.start()
	move_duration = 0.08
	print(move_duration)
	print("zoooooommmm")

func _on_speed_u_ptimer_timeout() -> void:
	$SpeedUPtimer.stop()
	move_duration = 0.1
	print(move_duration)
