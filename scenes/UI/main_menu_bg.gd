extends Node3D
@onready var animations: AnimationPlayer = $Animations

func _ready() -> void:
	animations.play("orbiting")
