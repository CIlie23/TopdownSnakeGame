extends Node3D
class_name SpeedAbility

@onready var timer: Timer = $Timer
var playerStuff = PlayerStuff.new()
var playerSpeed = playerStuff.move_duration

func speed_up():
	timer.start()
	playerSpeed = 0.08
	playerStuff.show_speed_particles()
	print(playerSpeed)
	print("zoooooommmm")

func _on_timer_timeout() -> void:
	timer.stop()
	playerSpeed = 0.1
	print(playerSpeed)
	#print("time end")


	
