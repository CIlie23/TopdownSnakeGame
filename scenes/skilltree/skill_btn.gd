extends TextureButton

class_name SkillNode

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line: Line2D = $Line2D
@onready var skill_btn: SkillNode = $"."

#@onready var skill_icon: Sprite2D = $SkillIcon
@onready var skill_icon: TextureRect = $TextureRect

#@export var skillAtributes: SkillAtribute
@export var skill_resource: Resource  
#@export var ability: Resource  
var player_stats = preload("res://scripts/player/player_stats.tres")
var ability = preload("res://scenes/skilltree/Skills/PlayerBuffs/skill_coldownReduction.tres")

func _ready():
	_skill_icon()
	if get_parent() is SkillNode:
		line.add_point(global_position + size/1)
		line.add_point(get_parent().global_position + size/1)
		
var level: int = 0:
	set(value):
		level = value
		label.text = str(level) + "/" + str(skill_resource.requiredPoints)
		
func _on_pressed():
	# Check if skill is already maxed
	if level >= skill_resource.requiredPoints:
		return
	
	if Global.available_skpoints <= 0:
		return
		
	Global.available_skpoints -= 1
	level += 1
	#level = min(level+1, skill_resource.requiredPoints) #max 3
	
	if Global.available_skpoints < skill_resource.requiredPoints:
		pass
	
	if level == skill_resource.requiredPoints:
		panel.show_behind_parent = true # to make the unlocked effect
		apply_skill_effects()
		line.default_color = Color(1, 1, 1)
	
		var skills = get_children()
		for skill in skills:
			if skill is SkillNode and level == skill_resource.requiredPoints:
				skill.disabled = false
			
#updates the skill icon
func _skill_icon():
	if skill_resource is SkillAtribute:
		var skillIcon = skill_resource.skillIcon #calling the skill icon var
		skill_icon.texture = skillIcon
	else:
		print("Missing skill icon!")

# WARNINGGG!! THIS IS NEEDED FOR THE EFFECTS TO WORK!!!!
func apply_skill_effects():
	if skill_resource is SkillAtribute:
		if player_stats is PlayerStats:
			player_stats.apply_skill_effect(skill_resource)

		if ability is AbilityAtributes:
			ability.apply_tree_effect(skill_resource)
	else:
		print("Invalid skill resource!")

#func apply_skill_effects():
	#if skill_resource is SkillAtribute and player_stats is PlayerStats:
		#player_stats.apply_skill_effect(skill_resource)
	#else:
		#print("Missing resource or type mismatch!")
