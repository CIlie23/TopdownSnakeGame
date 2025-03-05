extends Control

var is_skilltree_open = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("openskilltree"):
		if !is_skilltree_open:
			Engine.time_scale = 0
			opened()
		else:
			Engine.time_scale = 1
			closed()

func opened():
	visible = true
	is_skilltree_open = true
	
func closed():
	visible = false
	is_skilltree_open = false
