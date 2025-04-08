extends Node3D

signal capturing_progress(progress: float)

var spawn_radius: int = 25
var capture_time: float = 0.0
var capture_required: float = 10.0
var player_in_zone: bool = false

@onready var area: Area3D = $Area3D
@onready var capture_point: Node3D = $"."

func _ready() -> void:
	spawn_point()

func _process(delta: float) -> void:
	if player_in_zone:
		capture_time += delta
		var progress = clamp(capture_time / capture_required, 0.0, 1.0)
		emit_signal("capturing_progress", progress)
		print(progress)
		if progress >= 1.0:
			print(progress)
			print("Capture complete!")
			player_in_zone = false
			# Optional: reset or move again
			capture_time = 0.0
			spawn_point()  # Respawn for next use

func spawn_point():
	print("point spawned")
	capture_time = 0.0
	var random_position = Vector3(
		randf_range(-spawn_radius, spawn_radius), 
		-0.442,  # height
		randf_range(-spawn_radius, spawn_radius)
	)
	position += random_position  # Reposition the capture point itself

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_zone = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_zone = false


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	set_process(true)


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	set_process(false)
