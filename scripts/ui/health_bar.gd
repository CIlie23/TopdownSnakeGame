extends ProgressBar

@export var player_stats: PlayerStats

func _ready():
	if player_stats:
		# Connect the signal from PlayerStatsResource
		player_stats.health_changed.connect(update_healthbar)

		# Initialize Health Bar
		update_healthbar(player_stats.playerHealth, player_stats.max_playerHealth)

# Function to update the health bar when health changes
func update_healthbar(current_health, max_health):
	self.max_value = max_health
	self.value = current_health
	print("Health Bar Updated:", current_health, "/", max_health)
