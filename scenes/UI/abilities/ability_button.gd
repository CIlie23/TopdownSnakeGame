extends TextureButton
#----------------------------------------------------------------------------
# In this file all the input for the abilities is handled
#---------------------------------------------------------------------------- 
@onready var cooldown: TextureProgressBar = $Coldown
@onready var timer: Timer = $Timer
@onready var panel: Panel = $Panel
@onready var lbl_coldown: Label = $lblColdown
@onready var lbl_key: Label = $lblKey
@onready var ability_button: TextureButton = $"."
@onready var ability_icon: Sprite2D = $AbilityIcon

#@export var skill: Resource
@export var abilityAtributes: AbilityScript
@export var action_name: String 
@export var input_config: String 
@export var spell_number: int

@export var player_ability: PlayerAbility  # Assign the ability resource
@export var player: Node  # Assign the Player node
@export var playerStats = preload("res://scripts/player/player_stats_resource.tres")
var change_key = "":
	set(value):
		change_key = value
		lbl_key.text = value
 
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
 
		shortcut.events = [input_key]
 
func _ready():
	ability_icon.texture = abilityAtributes.abilityIcon
	timer.wait_time = abilityAtributes.abilityColdown
	lbl_key.text = input_config
	cooldown.max_value = timer.wait_time
	#cooldown.max_value = abilityAtributes.abilityColdown
	set_process(false)
 	
func _process(_delta):
	
	lbl_coldown.text = "%3.1f" % timer.time_left
	cooldown.value = timer.time_left
	#cooldown.value = abilityAtributes.abilityColdown
 
#----------------------------------------------------------------------------
# Yea no this code is a bit retarded but im in a hurry rn
# The "spell_number" is from "basic_ability_script.gd" and
# Basically it assigns a spell to each key
#---------------------------------------------------------------------------- 
func _on_pressed(): #add logic here to prvent from pressing again
	if Input.is_action_pressed("ability_one") and playerStats.mana >= 10:
		playerStats.mana -= 10
		abilityAtributes.use_ability_one(player)
	elif Input.is_action_pressed("ability_two") and playerStats.mana >= 50:
		playerStats.mana -= 50
		abilityAtributes.use_ability_two(player)
	elif Input.is_action_pressed("ability_tree") and playerStats.mana >= 30:
		playerStats.mana -= 30
		abilityAtributes.use_ability_three(player)
	elif Input.is_action_pressed("ability_four") and playerStats.mana >= 20:
		playerStats.mana -= 20
		abilityAtributes.use_ability_four(player)
	
	if playerStats.mana < abilityAtributes.abilityCost:
		print("disabled3")
		
		ability_button.disabled = true
	#current issue, make the button not pressable when no mana
	#is available
	
	timer.start()
	panel.show()
	lbl_coldown.show()
	set_process(true)

	ability_button.disabled = true
 
func _on_timer_timeout():
	cooldown.value = 0
	panel.hide()
	lbl_coldown.hide()
	set_process(false)
	ability_button.disabled = false
