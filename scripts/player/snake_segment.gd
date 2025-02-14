extends CharacterBody3D
var player: CharacterBody3D

func _process(delta):
	if player and player.position_queue.size() > 0:
		# Move the tail to the last position in the player's queue
		global_transform.origin = player.position_queue.pop_front()
