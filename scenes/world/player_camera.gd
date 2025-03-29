extends Camera3D

class_name lightningStrike

var LIGHTNING_STRIKE = preload("res://scenes/abilities/assets/lightning_strike.tscn")
@onready var main_node= get_node("/root/Spacial")

#func _input(event):
	#if event.is_action_pressed("click"):
		#shoot_ray()

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_lenght = 9000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_lenght
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_results = space.intersect_ray(ray_query)

	print(raycast_results)
	
	if !raycast_results.is_empty():
		var instance = LIGHTNING_STRIKE.instantiate()
		instance.position = raycast_results["position"]
		main_node.add_child(instance)
