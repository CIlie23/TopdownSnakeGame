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
@export var player_stats: Resource
#@export var sprIcon: Texture2D
#@export var atributes: Resource

func _ready():
	_skill_icon()
	if get_parent() is SkillNode:
		line.add_point(global_position + size/1)
		line.add_point(get_parent().global_position + size/1)
		
var level: int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"
		
func _on_pressed():
	level = min(level+1, 3) #max 3
	if level == 1:
		panel.show_behind_parent = true # to make the unlocked effect
		apply_skill_effects()
		
	line.default_color = Color(1, 1, 1)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == 3:
			skill.disabled = false
			
#updates the skill icon
func _skill_icon():
	if skill_resource is SkillAtribute:
		var skillIcon = skill_resource.skillIcon #calling the skill icon var
		skill_icon.texture = skillIcon
	else:
		print("Missing skill icon!")

func apply_skill_effects():
	if player_stats and skill_resource:
		skill_resource.apply_effects(player_stats)
		print("Max Health:", player_stats.max_playerHealth)
