extends Node

export var equippedGuns = []
var language = 0
var lastStagePlayed = 0
var guns := {}
var stages := {}
var currentScene = null
var wasInBossBattle = false
var itsAlreadyPaused = false

func _init():
	#pasta de armas
	var gunsDir := Directory.new()
	var error = gunsDir.change_dir("res://scenes/guns/")
	if (error != OK):
		if language == 0:
			printerr("Falha ao carregar a pasta de armas.")
		elif language == 1:
			printerr("Failed to open the guns folder.")
		return
		
	gunsDir.list_dir_begin(true, true)
	var next_file := gunsDir.get_next()
	while (next_file):
		if (next_file.get_extension() == "tscn"):
			guns[next_file] = load("res://scenes/guns/".plus_file(next_file))
		
		next_file = gunsDir.get_next()
		
	#armas equipadas
	equippedGuns = [null, null]
	equippedGuns.resize(2)
	
	#pasta de níveis
	var stagesDir := Directory.new()
	var error2 = stagesDir.change_dir("res://scenes/runnables/stages")
	if (error2 != OK):
		if language == 0:
			printerr("Falha ao carregar a pasta de níveis.")
		elif language == 1:
			printerr("Failed to open the stages folder.")
		return
		
	stagesDir.list_dir_begin(true, true)
	var next_file2 := stagesDir.get_next()
	while (next_file2):
		if (next_file2.get_extension() == "tscn"):
			stages[next_file2] = load("res://scenes/runnables/stages".plus_file(next_file2))
		
		next_file2 = stagesDir.get_next()
	
func _process(_delta):
	if equippedGuns[0] == equippedGuns[1]:
		equippedGuns[1] = null
	
func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	if int(typeof(path)) == 17:
		call_deferred("_deferred_goto_packedScene", path)
	else:
		call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	currentScene.free()
	var s = ResourceLoader.load(path)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
	get_node("Fade/layer/anim").play("fadeIn")
	
func _deferred_goto_packedScene(path):
	currentScene.free()
	currentScene = path.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
	get_node("Fade/layer/anim").play("fadeIn")
