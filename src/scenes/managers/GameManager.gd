extends Node

export var equippedGuns = []
var loadedMods = []
var language = 0
var lastStagePlayed = 0
var guns = []
var stages = []
var currentScene = null
var wasInBossBattle = false
var storedKills = 0
var storedScore = 0
var storedBitcoins = 0
var itsAlreadyPaused = false

func _init():
	#pasta de armas
	loadGuns()
		
	#######
	#ARMAS EQUIPADAS (ISSO É BEM SAGRADO)
	equippedGuns = [null, null]
	#NÃO TIRAR DE JEITO NENHUM OU O JOGO MORRE
	#######
	
	loadStages()
	
	load_equippedGuns()
	
func loadGuns():
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
			guns.push_back(load("res://scenes/guns/" + next_file))
		
		next_file = gunsDir.get_next()
	
func loadStages():
	var stagesDir := Directory.new()
	var errorStage = stagesDir.change_dir("res://scenes/runnables/stages")
	if (errorStage != OK):
		if language == 0:
			printerr("Falha ao carregar a pasta de níveis.")
		elif language == 1:
			printerr("Failed to open the stages folder.")
		return
		
	stagesDir.list_dir_begin(true, true)
	var next_stageFile := stagesDir.get_next()
	while (next_stageFile):
		if (next_stageFile.get_extension() == "tscn"):
			stages.push_back(load("res://scenes/runnables/stages/" + next_stageFile))
			
		next_stageFile = stagesDir.get_next()
	
func _process(_delta):
	if !equippedGuns[0] == null and !equippedGuns[1] == null:
		if equippedGuns[0] == equippedGuns[1]:
			equippedGuns[1] = null
	
func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	
func load_equippedGuns():
	var file = File.new()
	if not file.file_exists("user://equippedGuns.txt"):
		if language == 0:
			print("O arquivo salvo de armas equipadas não foi encontrada. Criando um novo...")
		if language == 1:
			print("The equipped guns save file was not found. Creating a new one...")
		save_equippedGuns(false)
		return
	if (file.open("user://equippedGuns.txt", File.READ)== OK):
		var loadedSlot1 = (file.get_line())
		var loadedSlot2 = (file.get_line())
		file.close()
		
		if loadedSlot1 == "null":
			equippedGuns[0] = null
		else:
			if int(loadedSlot1) > guns.size() - 1:
				equippedGuns[0] = null
			else:
				equippedGuns[0] = guns[int(loadedSlot1)]
			
		if loadedSlot2 == "null":
			equippedGuns[1] = null
		else:
			if int(loadedSlot2) > guns.size() - 1:
				equippedGuns[1] = null
			else:
				equippedGuns[1] = guns[int(loadedSlot2)]
			
func save_equippedGuns(ifFileFound : bool):
	if ifFileFound == true:
		var file = File.new()
		if (file.open("user://equippedGuns.txt", File.WRITE)== OK):
			if equippedGuns[0] == null:
				file.store_line(to_json(null))
			else:
				for i in guns.size():
					if equippedGuns[0] == guns[i]:
						file.store_line(to_json(str(i)))
			if equippedGuns[1] == null:
				file.store_line(to_json(null))
			else:
				for i in guns.size():
					if equippedGuns[1] == guns[i]:
						file.store_line(to_json(str(i)))
			file.close()
	elif !ifFileFound:
		var file = File.new()
		if (file.open("user://equippedGuns.txt", File.WRITE)== OK):
			file.store_line(to_json(str(0)))
			file.store_line(to_json(null))
			file.close()
	
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
