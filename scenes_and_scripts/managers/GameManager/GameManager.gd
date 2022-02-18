extends Node

enum PLATFORMS {
	PC,
	MOBILE
}

var menus = {
	"debug_menu": preload("res://scenes_and_scripts/runnables/menus/DebugMenu/DebugMenu.tscn"),
	"game_over": preload("res://scenes_and_scripts/runnables/menus/GameOverScreen/GameOverScreen.tscn"),
	"gundex": preload("res://scenes_and_scripts/runnables/menus/Gundex/Gundex.tscn"),
	"touchscreen_ui_settings": preload("res://scenes_and_scripts/runnables/menus/TouchscreenUISettings/TouchscreenUISettings.tscn"),
	"intro": preload("res://scenes_and_scripts/runnables/menus/intro/intro.tscn"),
	"loading": preload("res://scenes_and_scripts/runnables/menus/loading/loading.tscn"),
	"mods": preload("res://scenes_and_scripts/runnables/menus/mods/mods.tscn")
}

export(Array, PackedScene) var equippedGuns = [null, null]
var languageTemp := "pt"
var platform = PLATFORMS.MOBILE
var loadedMods := []
var language := 0
var lastStagePlayed := 0
var guns := []
var stages := []
var wasInBossBattle := false
var storedKills := 0
var storedScore := 0
var storedBitcoins := 0
var itsAlreadyPaused := false

onready var root = get_tree().get_root()
onready var currentScene = root.get_child(root.get_child_count() - 1)
onready var musicStream = $musicChannel

func _init():
	if OS.get_model_name().to_lower() == "android" or OS.get_model_name().to_lower() == "ios":
		platform = PLATFORMS.MOBILE
	
	TranslationServer.set_locale("pt")
	
	loadGuns()
	
	loadStages()
	
	load_equippedGuns()
	
func _process(_delta):
	if !equippedGuns[0] == null and !equippedGuns[1] == null:
		if equippedGuns[0] == equippedGuns[1]:
			equippedGuns[1] = null
	
func loadGuns():
	var dir = "res://scenes_and_scripts/guns/"
	var gunsDir := Directory.new()
	var error = gunsDir.change_dir(dir)
	if (error != OK):
		printerr("Failed to open the guns folder.")
		return
		
	gunsDir.list_dir_begin(true, true)
	var next_file := gunsDir.get_next()
	while next_file != "":
		if gunsDir.current_is_dir():
			var try = load(dir + next_file + "/" + next_file +".tscn")
			if try:
				guns.push_back(try)
				print("Succefully loaded gun located at: " + dir + next_file + "/scene.tscn.")
			else:
				printerr("Could not load gun located at: " + dir + next_file + "/scene.tscn.")
		next_file = gunsDir.get_next()
	guns.sort_custom(self, "sortGunsByID")
		
func sortGunsByID(a, b):
	if a.instance().ID < b.instance().ID:
		return true
	return false
	
func loadStages():
	var dir = "res://scenes_and_scripts/runnables/stages/"
	var stagesDir := Directory.new()
	var errorStage = stagesDir.change_dir(dir)
	if (errorStage != OK):
		printerr("Failed to open the stages folder.")
		return
		
	stagesDir.list_dir_begin(true, true)
	var next_file := stagesDir.get_next()
	while next_file != "":
		if stagesDir.current_is_dir():
			var dirToTry = dir + next_file + "/" + next_file + ".tscn"
			var try = load(dirToTry)
			if try:
				stages.push_back(try)
				print("Succefully loaded stage located at: " + dirToTry)
			else:
				printerr("Could not load stage located at: " + dirToTry)
		next_file = stagesDir.get_next()
	
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
	var fadeTime = 0.25
	var fadeTween = Tween.new()
	add_child(fadeTween)
	
	$fadeLayer.offset = Vector2(0, 0)
	fadeTween.interpolate_property($fadeLayer/fade, "modulate", Color(0,0,0,0), Color(0,0,0,1), fadeTime, Tween.TRANS_LINEAR)
	fadeTween.start()
	yield(fadeTween, "tween_all_completed")
	currentScene.free()
	if not int(typeof(path)) == 17:
		var s = ResourceLoader.load(path)
		currentScene = s.instance()
	else:
		currentScene = path.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
	fadeTween.interpolate_property($fadeLayer/fade, "modulate", Color(0,0,0,1), Color(0,0,0,0), fadeTime, Tween.TRANS_LINEAR)
	fadeTween.start()
	yield(fadeTween, "tween_all_completed")
	$fadeLayer.offset = Vector2(-1280, -720)
	fadeTween.queue_free()
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			if !itsAlreadyPaused:
				get_tree().paused = false
