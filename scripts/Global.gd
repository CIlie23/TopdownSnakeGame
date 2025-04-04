extends Node

@export var total_enemies:int = 0
@export var total_enemy_kills: int = 0
@export var available_skpoints: int = 0
@export var money:int = 0

var plasma_kills := 0
var lightning_kills := 0

func report_enemy_killed_by(type: String) -> void:
	match type:
		"plasma":
			plasma_kills += 1
		"lightning":
			lightning_kills += 1
	
	print("Killed by:", type)
	print(plasma_kills)
