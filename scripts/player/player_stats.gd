extends Resource
class_name PlayerStats

@export var playerHealth: int
@export var max_playerHealth: int
@export var armor: int
@export var maxArmor: int

signal health_changed(new_health, max_health)

func apply_stat_boost(effect: String, value: int):
	match effect:
		"health boost":
			print("boosted")
			playerHealth = min(playerHealth + value, max_playerHealth)
			max_playerHealth += value
			health_changed.emit(playerHealth, max_playerHealth)
			print("Health increased by ", value, "| New Health:", playerHealth, "| Max Health:", max_playerHealth)
		"armor boost":
			armor += value
			print("Armor increased by ", value, "| New Armor:", armor, "| Max Armor:", maxArmor)
