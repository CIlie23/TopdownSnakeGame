extends Resource
class_name PlayerStats

@export var playerHealth: int
@export var max_playerHealth: int
@export var healthRegen: float = 2.0
@export var intelligence: int #i lack here

@export var armor: int
@export var maxArmor: int
@export var mana: int
@export var maxMana: int
@export var manaRegen: float = 2.0

signal health_changed(new_health, max_health)
signal mana_grown(new_mana, max_mana)

func apply_skill_effect(skill: SkillAtribute):
	match skill.stat_to_increase:
		"maxHealth":
			max_playerHealth += skill.value
		"healthRegen":
			healthRegen += skill.value
		"manaRegen":
			manaRegen += skill.value
		"maxMana":
			maxMana += skill.value
		"unlockSkilltree":
			intelligence += skill.value
		#"decreaseColdown":
			#intelligence += skill.value
		_:
			print("Unknown stat: ", skill.stat_to_increase)
