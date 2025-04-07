extends Resource
class_name AbilityAtributes 

# this is connected to the abilities
# check in the ui for the ability buttons

@export var abilityName: String
@export var abilityIcon: Texture2D

@export var abilityCost: int
@export var description: String

@export var abilityColdown: float

# FIX THESE

func apply_tree_effect(skill: SkillAtribute):
	match skill.stat_to_increase:
		"decreaseColdown":
			abilityColdown = max(0.0, abilityColdown - skill.value)
		"reduceCost":
			abilityCost = max(0, abilityCost - int(skill.value))
		_:
			print("Unknown stat: ", skill.stat_to_increase)
