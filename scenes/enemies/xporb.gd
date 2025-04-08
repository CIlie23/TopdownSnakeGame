extends Node3D

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles3D = $GPUParticles3D

#func _ready() -> void:
	#animation_player.play("orb_appear")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#body.extend()
		Global.available_skpoints += 1
		queue_free()

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	#animations.play("orb_appear")
	particles.emitting = true
	#set_process(true)
	
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	#animations.stop()
	particles.emitting = false
	#set_process(false)

func _on_lifetime_timeout() -> void:
	queue_free()
