extends TextureRect
@onready var item_icon: Sprite2D = %ItemIcon

var item: InvItem

func _ready():
	if item:
		texture = item.texture
# ----------------------------------------------------------------------------
# Handles the drag-and-drop system for moving inventory items
# ----------------------------------------------------------------------------	
func _get_drag_data(at_position):
	var preview = TextureRect.new()
	
	preview.texture = texture
	preview.custom_minimum_size = Vector2(32, 32)  # Adjust size as needed
	set_drag_preview(preview)
	return item  # Send item data to the drop zone
	
func _can_drop_data(_pos, data):
	#return data is Texture2D
	return data is InvItem
 
func _drop_data(_pos, data):
	#texture = data
	item = data
	texture = item.texture
