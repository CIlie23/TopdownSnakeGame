extends Control

signal weapon_selected(weapon_type: String)

@export var available_weapons := ["turretOne", "doubleTurret", "cannon", "machineGun"]

func _ready() -> void:
	var container = $GridContainer
	for weapon in available_weapons:
		var button = TextureButton.new()
		
		var btnTexture = "res://assets/ui/weaponIcons/%s.png" % weapon
		var texture = load(btnTexture)
		button.texture_normal = texture
		
		button.connect("pressed", Callable(self, "_on_weapon_pressed").bind(weapon))
		container.add_child(button)
	
func _on_weapon_pressed(weapon_type: String):
	emit_signal("weapon_selected", weapon_type)
	queue_free()
	
