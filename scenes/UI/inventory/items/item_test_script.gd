extends TextureRect
#@onready var item_icon: Sprite2D = %ItemIcon

signal item_clicked
signal item_dropped

var item: InvItem

func _ready():
	if item:
		texture = item.texture
# ----------------------------------------------------------------------------
# Handles the drag-and-drop system for moving inventory items
# ----------------------------------------------------------------------------	
func _get_drag_data(at_position):
	var preview = TextureRect.new()
	item_clicked.emit()
	preview.texture = texture
	preview.custom_minimum_size = Vector2(32, 32)  # Adjust size as needed

	set_drag_preview(preview)
	
	# Store the current item in drag data before nullifying the texture
	var drag_data = item
	texture = null
	item = null  # Clear item reference

	return drag_data  # Return the InvItem instead of just the texture

	
func _can_drop_data(_pos, data):
	#return data is Texture2D
	return data is InvItem
 
func _drop_data(_pos, data):
	if data is InvItem:
		item = data  # Assign the dropped item
		texture = item.texture  # Update the texture to match the item

#func _drop_data(_pos, data):
	#texture = data
	#item = data
	#texture = item.texture
