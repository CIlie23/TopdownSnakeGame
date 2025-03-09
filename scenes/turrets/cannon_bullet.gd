extends Node3D

# Should probably rewrite this l8r so it's a resource
# In case I wanna reuse it for something else
# Rn this script is also used for the plasma_ball

@onready var timer: Timer = $Timer
@onready var cannonBall: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var ray: RayCast3D = $RayCast3D

@export var SPEED: float

func _ready():
	pass
	
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		cannonBall.visible = false
		particles.emitting = true
		await get_tree().create_timer(1,0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	print("cannon bullet deleted")
	queue_free()
