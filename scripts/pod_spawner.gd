extends Node3D

var pod_scene = preload("res://scenes/enemies/landingpod/pod.tscn")  # Store scene reference
var spawn_radius = 25

func _on_pod_spawn_timer_timeout() -> void:
	var random_position = Vector3(
		randf_range(-spawn_radius, spawn_radius), 
		1,  # Adjust the height (-1) as needed
		randf_range(-spawn_radius, spawn_radius)
	)

	var pod_instance = pod_scene.instantiate()  # Instantiate the pod
	pod_instance.position = position + random_position  # Assign a random position
	get_parent().add_child(pod_instance)  # Add to the scene

	#print("Pod spawned at: ", pod_instance.position)
