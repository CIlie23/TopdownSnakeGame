extends Node3D
class_name SpeedAbility

@onready var timer: Timer = $Timer
var playerStuff = PlayerStuff.new()
var playerSpeed = playerStuff.move_duration
@onready var particles = get_node("/root/Spacial/Player/SpeedParticles")
#@onready var camera = get_node("/root/Spacial/Player/Camera")
@onready var camera = get_node("/root/Spacial/Player/CameraAnims")

var camera_size = 10.5
var lerp_speed = 50.0


func speed_up():
	timer.start()
	playerSpeed = 0.08
	camera.play("cameZoomOUT")
	#playerStuff.show_speed_particles()
	particles.emitting = true
	print(playerSpeed)
	print("zoooooommmm")

#func lerp_cam():
	#camera.size = move_toward(camera.size, camera_size, lerp_speed)
#
#func unlerp_cam(delta):
	#camera.size = lerp(camera.size, 10, delta * lerp_speed)

func _on_timer_timeout() -> void:
	timer.stop()
	playerSpeed = 0.1
	camera.play("cameraZoomIN")
	particles.emitting = false
	print(playerSpeed)
	#print("time end")


	
