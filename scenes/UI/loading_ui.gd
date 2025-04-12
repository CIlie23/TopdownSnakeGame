extends Control

@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var progress_text: Label = $Panel/ProgressText

var progress = []
var sceneName
var scene_load_status = 0

func _ready() -> void:
	sceneName = "res://scenes/Game.tscn"
	ResourceLoader.load_threaded_request(sceneName)
	
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	#progress_text.text = str(floor(progress[0]*100)) + "%"
	progress_bar.value = floor(progress[0]*100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
