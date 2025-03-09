extends Resource
class_name AbilityScript

@export var abilityName: String
@export var abilityIcon: Texture2D
@export var abilityShortcut: String

@export var description: String

@export var abilityColdown: float
@export var abilityEffect: PlayerAbility

#----------------------------------------------------------------------------
# Horrible, horrible, HORRIBLE spaghetti, I'm sorry to my ancestors 
# for writing code THIS bad
#---------------------------------------------------------------------------- 

func use_ability_one(player):
	abilityEffect._cast_spell_one(player)

func use_ability_two(player):
	abilityEffect._cast_spell_two(player)
	
func use_ability_three(player):
	abilityEffect._cast_spell_three(player)

func use_ability_four(player):
	abilityEffect._cast_spell_four(player)
