extends Control

@onready var title: Label = $VBoxContainer/Title
@onready var dialogue: RichTextLabel = $VBoxContainer/Dialogue
@onready var ok_button: Button = $Box/okButton
@onready var type_writer_effect: AnimationPlayer = $VBoxContainer/TypeWriterEffect

func display_line(line : String, speaker : String = ""):
	title.visible = (speaker != "")
	title.text = speaker
	dialogue.text = line
	type_writer_effect.play("typewriter") #https://www.youtube.com/watch?v=jWDrNAbps7Q
	open()

func open():
	#Engine.time_scale = 0
	visible = true
	
func close():
	#get_tree().paused = false
	#Engine.time_scale = 1
	visible = false


func _on_ok_button_pressed() -> void:
	
	print("Hello")
	close()


func _on_type_writer_effect_animation_finished(anim_name: StringName) -> void:
	ok_button.grab_focus() # Focus the OK button after typing finishes
