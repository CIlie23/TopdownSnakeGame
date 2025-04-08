extends Control

class_name GameOver

#var playerStats = preload("res://scripts/player/player_stats_resource.tres")
@export var playerStats: PlayerStats
@onready var game_over: Control = $"."

func show_UI():
	game_over.visible = true


func _on_try_again_pressed() -> void:
	playerStats.playerHealth = 100
	playerStats.mana = 100
	game_over.visible = false
	#Engine.time_scale = 1
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_give_up_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
