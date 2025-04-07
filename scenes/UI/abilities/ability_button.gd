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
@onready var abil_disabled: Sprite2D = $AbilDisabled

@onready var camera_path = get_node("/root/Spacial/Player/Camera")
#@export var skill: Resource
@export var abilityAtributes: AbilityAtributes
#@export var action_name: String 
@export var input_config: String 
#@export var spell_number: int
var player = null
var change_key = "":
	set(value):
		change_key = value
		lbl_key.text = value
 
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
 
		shortcut.events = [input_key]
 
@export var playerStats = preload("res://scripts/player/player_stats_resource.tres")

func _ready(): #figure out how to connect stuff
	player = get_node("/root/Spacial/Player")
	ability_icon.texture = abilityAtributes.abilityIcon
	timer.wait_time = abilityAtributes.abilityColdown
	lbl_key.text = input_config
	cooldown.max_value = timer.wait_time
	#cooldown.max_value = abilityAtributes.abilityColdown
	set_process(false)
 	
func _process(_delta):
	#if playerStats.mana < abilityAtributes.abilityCost:
		#abil_disabled.visible = true
	#elif playerStats.mana >= abilityAtributes.abilityCost:
		#abil_disabled.visible = false
	lbl_coldown.text = "%3.1f" % timer.time_left
	cooldown.value = timer.time_left
	#cooldown.value = abilityAtributes.abilityColdown
 
#----------------------------------------------------------------------------
# The Ability.new() is for the ability scene itself, for example, for the
# DroneSwarm ability scene
#---------------------------------------------------------------------------- 
#@export var abilityAtribute: Resource
var SPEED_BOOST = preload("res://scenes/abilities/assets/speed_boost.tscn")
var DRONE_SWARM = preload("res://scenes/abilities/drone_swarm/drone_swarm.gd")

#var droneswarmScene
var speedUpScene 

func _on_pressed(): #add logic here to prvent from pressing again
	if playerStats.mana < abilityAtributes.abilityCost:
		print("Not enough mana")
		ability_button.disabled = true
		return
	else:
		abil_disabled.visible = false
		timer.start()
		panel.show()
		lbl_coldown.show()
		set_process(true)

	ability_button.disabled = true
		
	if Input.is_action_pressed("ability_one"):
		print(abilityAtributes.abilityColdown, " seconds")
		if playerStats.mana < abilityAtributes.abilityCost:
			print("Not enough mana")
		else:
			player.shoot_plasmaball()
		playerStats.mana -= abilityAtributes.abilityCost
	elif Input.is_action_pressed("ability_two") and playerStats.mana >= 50:
		if playerStats.mana < abilityAtributes.abilityCost:
			print("Not enough mana")
		else:
			camera_path.shoot_ray()
		playerStats.mana -= abilityAtributes.abilityCost
	elif Input.is_action_pressed("ability_tree") and playerStats.mana >= 30:
		if playerStats.mana < abilityAtributes.abilityCost:
			print("Not enough mana")
		else:
			speedUpScene = SPEED_BOOST.instantiate()
			add_child(speedUpScene)
			speedUpScene.speed_up()
		playerStats.mana -= abilityAtributes.abilityCost
	elif Input.is_action_pressed("ability_four") and playerStats.mana >= 20:
		playerStats.mana -= abilityAtributes.abilityCost
		#if playerStats.mana < abilityAtributes.abilityCost:
			#print("Not enough mana")
		#else:
		var droneswarmScene = preload("res://scenes/abilities/drone_swarm/drone_swarm.tscn")
		var droneInst = droneswarmScene.instantiate()
		add_child(droneInst)
		droneInst.activate_ability(player)
			
func _on_timer_timeout():
	cooldown.value = 0
	panel.hide()
	lbl_coldown.hide()
	set_process(false)
	ability_button.disabled = false
