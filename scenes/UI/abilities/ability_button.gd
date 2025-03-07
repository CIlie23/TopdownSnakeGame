extends TextureButton

@onready var cooldown: TextureProgressBar = $Coldown
@onready var timer: Timer = $Timer
@onready var panel: Panel = $Panel
@onready var lbl_coldown: Label = $lblColdown
@onready var lbl_key: Label = $lblKey

@export var skill: Resource
 
var change_key = "":
	set(value):
		change_key = value
		lbl_key.text = value
 
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
 
		shortcut.events = [input_key]
 
func _ready():
	lbl_key.text = InputMap.action_get_events("ability_two")[0].as_text().replace(' (Physical)','') 
	#change_key = "1"
	cooldown.max_value = timer.wait_time
	set_process(false)
 
func _process(_delta):
	lbl_coldown.text = "%3.1f" % timer.time_left
	cooldown.value = timer.time_left
 
 
func _on_pressed():
	print("test")
	timer.start()
	panel.show()
	lbl_coldown.show()
	set_process(true)
	#lbl_coldown.text = "%3.1f" % timer.time_left
 
func _on_timer_timeout():
	cooldown.value = 0
	panel.hide()
	lbl_coldown.hide()
	set_process(false)
