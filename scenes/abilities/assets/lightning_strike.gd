extends Node3D

class_name lightningScene

@onready var lightning_mesh: MeshInstance3D = $LightningMesh
@onready var lightning_particles: GPUParticles3D = $LightningParticles
var lightningDamage: int = 50

func _ready() -> void:
	lightning_particles.emitting = true
	lightning_mesh.visible = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.takeDamage(50, "lightning")

func hit():
	print("Hit")

func _on_existence_timer_timeout() -> void:
	queue_free()
