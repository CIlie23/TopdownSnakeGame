extends Control

signal weapon_selected(weapon_type: String)

@export var available_weapons := ["turretOne", "doubleTurret", "cannon", "machineGun"]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var container = $PanelContainer/GridContainer
	for weapon in available_weapons:
		var button = TextureButton.new()
		var btnTexture = "res://assets/turrets/weaponIcons/%s.png" % weapon
		var texture = load(btnTexture)
		button.texture_normal = texture
		
		button.connect("pressed", Callable(self, "_on_weapon_pressed").bind(weapon))
		container.add_child(button)
	
func _on_weapon_pressed(weapon_type: String):
	emit_signal("weapon_selected", weapon_type)
	#Engine.time_scale = 1
	get_tree().paused = false
	queue_free()
	
