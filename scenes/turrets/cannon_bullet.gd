extends Node3D

class_name plasmaBall

# Should probably rewrite this l8r so it's a resource
# In case I wanna reuse it for something else
# Rn this script is also used for the plasma_ball

#var gunnerRobotScript = preload("res://scenes/enemies/rifle_robot/gunner_robot.gd")
#var gunner = gunnerRobotScript.new()

@onready var timer: Timer = $Timer
@onready var cannonBall: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var ray: RayCast3D = $RayCast3D
@onready var dmgArea: Area3D = $Area3D

@export var SPEED: float
@export var plasmaBallDAMAGE: int = 50;

func _ready():
	pass
	
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		cannonBall.visible = false
		particles.emitting = true
		#if ray.get_collider().is_in_group("Enemy"):
			#ray.get_collider().hit()
		await get_tree().create_timer(1,0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	print("cannon bullet deleted")
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.plasmaBallHit()
