extends Resource
class_name PlayerAbility

#----------------------------------------------------------------------------
# This code handles ALL the player ABILITIES
#----------------------------------------------------------------------------

@export var ability_scene: PackedScene 
@export var spell_cost: int

func _cast_spell_one(player):
	if player.has_method("_shoot_plasmaball"):
		player._shoot_plasmaball()  # Calls the function in Player.gd
	else:
		print("Player does not have a cast_projectile function!")

func _cast_spell_two(player):
	print("Lightning storm")

func _cast_spell_three(player):
	if player.has_method("_speed_up"):
		player._speed_up()  # Calls the function in Player.gd
	else:
		print("Player does not have a cast_projectile function!")

func _cast_spell_four(player):
	if player.has_method("_spawn_swarm"):
		player._spawn_swarm(player)  # Calls the function in Player.gd
	else:
		print("Player does not have a cast_projectile function!")

#----------------------------------------------------------------------------
# This code handles all the player ABILITIES
#----------------------------------------------------------------------------
