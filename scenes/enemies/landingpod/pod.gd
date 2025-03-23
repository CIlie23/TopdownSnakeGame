extends CharacterBody3D

var spawned_enemies = 0 
var spawnSize = randi_range(3, 6)

var gravity = 30

var enemyArray = [
	preload("res://scenes/enemies/chaser/enemy_mimic.tscn"),
	preload("res://scenes/enemies/rifle_robot/robot_fella.tscn"),
	preload("res://scenes/enemies/small_Drone/small_drone.tscn")
]

func _on_spawn_timer_timeout() -> void:
	spawnSize = randi_range(3, 6)
	if spawned_enemies <= spawnSize:
		var random_enemy_scene = enemyArray.pick_random()
		var enemy = random_enemy_scene.instantiate()
		
		var spawn_radius = 3.5  # Adjust the radius as needed
		var random_offset = Vector3(randf_range(-spawn_radius, spawn_radius), -1, randf_range(-spawn_radius, spawn_radius))
		
		enemy.position = position + random_offset  # Offset the enemy from the spawner
		get_parent().add_child(enemy)
		
		spawned_enemies += 1
		#print(spawned_enemies)
		if spawned_enemies >= spawnSize:
			#print("deleted")
			queue_free()

	
