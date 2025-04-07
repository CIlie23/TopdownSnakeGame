extends Control
#----------------------------------------------------------------------------
# Handles the GUI and updates each inventory slot
#----------------------------------------------------------------------------
@onready var inv: Inv = preload("res://scenes/UI/inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_inventory_open = false

signal item_out_of_inventory

func _ready() -> void:
	update_slots()
	closed()

# ----------------------------------------------------------------------------
# Updates the inventory slots to match the player's inventory data
# ----------------------------------------------------------------------------
func update_slots():
	for i in range(slots.size()):
		if i < inv.items.size():
			slots[i].update(inv.items[i])  # Call the update() method in inv_slot.gd
		else:
			slots[i].update(null)  # Clear empty slots

#func update_slots():
	#for i in range(min(inv.items.size(), slots.size())):
		#slots[i].update(inv.items[i])
# ----------------------------------------------------------------------------
# Handles opening and closing inventory with the assigned key
# ----------------------------------------------------------------------------
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("open_inventory"):
		#if !is_inventory_open:
			#opened()
		#else:
			#closed()

func opened():
	visible = true
	is_inventory_open = true
	
func closed():
	visible = false
	is_inventory_open = false

func _on_button_pressed() -> void:
	closed()

func _on_inv_ui_slot_item_out_of_slot() -> void:
	item_out_of_inventory.emit()
