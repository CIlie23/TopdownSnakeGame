extends ProgressBar
#also updates the mana bar!
@export var player_stats: PlayerStats
@onready var mana_bar: ProgressBar = $"../ManaBar"
var regen_amount: float = 0.1
func _ready():
	if player_stats:
		# Connect the signal from PlayerStatsResource
		player_stats.health_changed.connect(update_healthbar)

		# Initialize Health Bar
		update_healthbar(player_stats.playerHealth, player_stats.max_playerHealth)
		update_manabar(player_stats.mana, player_stats.maxMana)
# Function to update the health bar when health changes
func _process(delta: float) -> void:
	if Input.is_action_pressed("killAll"):
		mana_bar.value = 0
		
func _physics_process(delta: float) -> void:
	if mana_bar.value >= 100:
		pass
	else:
		mana_bar.value = min(mana_bar.value + regen_amount, 100)
	
func update_healthbar(current_health, max_health):
	self.max_value = max_health
	self.value = current_health
	print("Health Bar Updated:", current_health, "/", max_health)

func update_manabar(current_mana, max_mana):
	self.max_value = max_mana
	self.value = current_mana
