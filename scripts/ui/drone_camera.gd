extends Control

@onready var sub_viewport: SubViewport = $droneCamera/SubViewport

func _ready():
	if sub_viewport:
		var tex = sub_viewport.get_texture()
		$droneCamera.texture = tex
	else:
		print("Viewport not assigned!")
