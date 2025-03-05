extends Control

#@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var item_visual: TextureRect = $CenterContainer/TextureRect

signal item_out_of_slot

func _process(delta: float) -> void:
	pass

# Function to update the visual representation of the inventory slot		
#func update(item: InvItem):
	#if !item:
		#item_visual.visible = false
	#else:
		#item_visual.visible = true
		#item_visual.texture = item.texture
# ----------------------------------------------------------------------------
# Called when an inventory slot is updated with a new item
# ----------------------------------------------------------------------------
func update(new_item: InvItem):
	if new_item:
		item_visual.item = new_item
		item_visual.texture = new_item.texture
	else:
		item_visual.item = null
		item_visual.texture = null  # Remove the texture if slot is empty

func can_drop_data(_pos, data):
	return data is InvItem  # Allow only InvItem resources

func drop_data(_pos, data):
	item_visual.item = data  # Assign item to the slot
	item_visual.texture = data.texture  # Update the display

func _on_texture_rect_item_clicked() -> void:
	item_out_of_slot.emit()
