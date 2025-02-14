extends RayCast3D

var last_hovered: Node3D = null

func _process(delta):
	if not is_colliding():
		if last_hovered:
			last_hovered.get_node("Outline").visible = false
			last_hovered = null
		return

	var hit_obj = get_collider()

	if hit_obj and hit_obj.is_in_group("hoverable"):
		if last_hovered and last_hovered != hit_obj:
			last_hovered.get_node("Outline").visible = false
		
		hit_obj.get_node("Outline").visible = true
		last_hovered = hit_obj
