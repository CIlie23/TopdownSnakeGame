extends Node3D
class_name Ability

#var AbilityAtribute: AbilityScript
#@export var droneSwarmAtributes: Resource

var drones: Array = []
@export var max_drones: int
@export var spawn_radius: float = 2.0

@onready var drone_scene = preload("res://scenes/friends/turret_drone.tscn")
#var player = preload("res://scripts/player/player.gd")
	
func activate_ability(player: Node3D):
	if drones.size() < max_drones:
		for i in range(max_drones):
			#var angle = (PI * 2 / max_drones) * i  # Spread them evenly in a circle
			#var spawn_position = player.position + Vector3(cos(angle), 0, sin(angle)) * spawn_radius
			var spawn_position = Vector3(randi_range(1, 5), 0, randi_range(1, 5)) * spawn_radius
			var drone = drone_scene.instantiate()
			drone.position = spawn_position
			#drone.set_owner(player)  # Set the player as the owner
			#drone.player = player  # Assign player reference for AI behavior

			#player.get_parent().add_child(drone)  # Spawn in world
			add_child(drone)
			print("oooo Drone swarmmm!")
