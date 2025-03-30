extends Resource
class_name SkillAtribute

@export var skill_name: String
@export var skillIcon: Texture2D
@export var description: String

@export var effects: Dictionary = {
	"armor boost": 5 #change this every time you wanna update a stat?
}

func apply_effects(player_stats: PlayerStats):
	pass
	#for effect in effects.keys():
		#var value = effects[effect]
		#player_stats.apply_stat_boost(effect, value)
