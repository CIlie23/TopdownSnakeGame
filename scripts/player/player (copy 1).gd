extends CharacterBody3D
#https://gdscript.com/projects/3d-snake-game-in-godot/

var direction = Vector3()
var last_used_direction = direction
var snake_bodies = []
var tail_piece = preload("res://scenes/world/snake_segment.tscn")
var SPEED = 100

func _process(delta):
	# Check for the input action
	if Input.is_action_just_pressed("extend_snake"):
		extend()

func _unhandled_key_input(event):
	#if event.is_action("ui_accept"):
		#$Timer.start() #when the timer starts i move and the speed i move at is dependent by the timer
		#direction = Vector3(1, 0, 0)
	
	if event.is_action_pressed('game_up'):
		direction = Vector3(0, 0, -1)
	elif event.is_action_pressed('game_down'):
		direction = Vector3(0, 0, 1)
	elif event.is_action_pressed('game_left'):
		direction = Vector3(-1, 0, 0)
	elif event.is_action_pressed('game_right'):
		direction = Vector3(1, 0, 0)


func _on_timer_timeout():
	var old_position = position
	velocity = direction * SPEED  # Assuming you have a speed variable
	move_and_slide()

	for body in snake_bodies:
		var temp_position = body.position
		body.position = old_position
		old_position = temp_position

	#if get_slide_collision_count() > 0:
		#reset_scene()

func get_positions() -> Array:
	var all_positions = []
	all_positions.append(position)
	for body in snake_bodies:
		all_positions.append(body.position)
	return all_positions

func extend() -> void:
	# Instantiate a new body segment
	var new_body = tail_piece.instantiate()
	
	# Position the new segment at the current head position (or last body segment)
	if snake_bodies.size() > 0:
		new_body.position = snake_bodies[-1].position  # Place it at the last body segment's position
	else:
		new_body.position = position  # Place it at the head's position
	
	# Add the new segment to the list of body segments
	snake_bodies.append(new_body)
	
	# Add the new segment to the scene tree
	get_tree().current_scene.add_child(new_body)
