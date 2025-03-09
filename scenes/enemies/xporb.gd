extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.extend()
		queue_free()
	else:
		print("somewhere for some reason went wrong")
