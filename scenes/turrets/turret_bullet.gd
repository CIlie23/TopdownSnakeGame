extends Node3D
#https://godotforums.org/d/38815-adding-enemies-who-can-shoot-the-player/2
@onready var mesh: MeshInstance3D = $MeshInstance3D
#@onready var ray: RayCast3D = $RayCast3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var timer: Timer = $Timer

@onready var bullet_shape: CollisionShape3D = $BulletColision/bulletShape

const SPEED: float = 300.0

func _ready():
	pass
	
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta


func _on_timer_timeout() -> void:
	queue_free()
	#print("deleted")


func _on_bullet_colision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		mesh.visible = false
		particles.emitting = true
		#_target_hit()
		body.takeDamage(1, "plasma")
		await get_tree().create_timer(1,0).timeout
		queue_free()
