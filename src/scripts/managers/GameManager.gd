extends Node

export var equippedGuns = []
var language = 0
var guns := {}
var currentScene = null

func _init():
	var gunsDir := Directory.new()
	var error = gunsDir.change_dir("res://scenes/guns/")
	if (error != OK):
		if language == 0:
			printerr("Falha ao carregar a pasta de armas.")
		elif language == 1:
			printerr("Failed to open guns folder.")
		return
		
	gunsDir.list_dir_begin(true, true)
	var next_file := gunsDir.get_next()
	while (next_file):
		if (next_file.get_extension() == "tscn"):
			guns[next_file] = load("res://scenes/guns/".plus_file(next_file))
		
		next_file = gunsDir.get_next()
		
	equippedGuns = [null, null]
	equippedGuns.resize(2)
	
func _process(_delta):
	if equippedGuns[0] == equippedGuns[1]:
		equippedGuns[1] = null
	
func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	currentScene.free()
	var s = ResourceLoader.load(path)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
	get_node("Fade/layer/anim").play("fadeIn")
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
