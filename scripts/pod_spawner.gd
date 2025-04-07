extends Node3D
@onready var pod_spawn_timer: Timer = $PodSpawnTimer

var pod_scene = preload("res://scenes/enemies/landingpod/pod.tscn")  # Store scene reference
var spawn_radius = 15 #how far the pods spawn from each other


func _ready() -> void:
	for i in range(3):
		spawn_pods()
	
func _process(delta: float) -> void:
	check_spawn_timer()
		
func _on_pod_spawn_timer_timeout() -> void:
		spawn_pods()

func check_spawn_timer():
	if Global.total_enemies >= 20 and !pod_spawn_timer.is_stopped():
		pod_spawn_timer.stop()
		print("pod spawning stopped")
	elif Global.total_enemies < 15 and pod_spawn_timer.is_stopped():
		pod_spawn_timer.start()
		print("pod spawning started")

func spawn_pods():
	var random_position = Vector3(
		randf_range(-spawn_radius, spawn_radius), 
			1,  # Adjust the height (-1) as needed
			randf_range(-spawn_radius, spawn_radius)
		)
	var pod_instance = pod_scene.instantiate()  # Instantiate the pod
	pod_instance.position = position + random_position  # Assign a random position
	get_parent().add_child.call_deferred(pod_instance)  # Add to the scene
	#print("Pod spawned at: ", pod_instance.position)
