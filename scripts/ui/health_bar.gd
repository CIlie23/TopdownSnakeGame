extends ProgressBar
#also updates the mana bar!
@export var player_stats: PlayerStats
@onready var mana_bar: ProgressBar = $"../ManaBar"
var regen_amount: float = 0.1
@onready var health_bar: ProgressBar = $"."
#var player_stats = preload("res://scripts/player/player_stats.tres")

func _ready():
	if player_stats:
		# Connect the signal from PlayerStatsResource
		player_stats.health_changed.connect(update_healthbar)

		# Initialize Health Bar
		update_healthbar(player_stats.playerHealth, player_stats.max_playerHealth)
		
func _process(delta: float) -> void:
	if player_stats.playerHealth < player_stats.max_playerHealth:
		update_healthbar(player_stats.playerHealth, player_stats.max_playerHealth)
		
func _physics_process(delta: float) -> void:
	if health_bar.value >= 100:
		pass
	else:
		health_bar.value = min(health_bar.value + regen_amount, 100)
	
func update_healthbar(current_health, max_health):
	health_bar.max_value = max_health
	health_bar.value = current_health
