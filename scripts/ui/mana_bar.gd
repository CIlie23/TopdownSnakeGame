extends ProgressBar
#also updates the mana bar!
@export var player_stats: PlayerStats
@onready var mana_bar: ProgressBar = $"../ManaBar"
var regen_amount: float = 0.1
@onready var health_bar: ProgressBar = $"."

func _ready():
	if player_stats:
		update_manabar(player_stats.mana, player_stats.maxMana)
# Function to update the health bar when health changes

func _process(delta: float) -> void:
	if player_stats.mana < player_stats.maxMana:
		update_manabar(player_stats.mana, player_stats.maxMana)
	if Input.is_action_pressed("killAll"):
		mana_bar.value = 0
		
func _physics_process(delta: float) -> void:
	if mana_bar.value >= 100:
		pass
	else:
		mana_bar.value = min(mana_bar.value + regen_amount, 100)
	
func update_manabar(current_mana, max_mana):
	mana_bar.max_value = max_mana
	mana_bar.value = current_mana
