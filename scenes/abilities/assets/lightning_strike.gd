extends Node3D

@onready var beam: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $GPUParticles3D


func _ready() -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	hit()

func hit():
	print("Hit")
