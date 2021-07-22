extends Node2D

var detectedMods = []
	
func _ready():
	if GameManager.language == 0:
		$GoBack.text = "Voltar"
		$ErrorText.text = "A pasta de mods não pôde ser carregada."
	if GameManager.language == 1:
		$GoBack.text = "Go back"
		$ErrorText.text = "The mods folder could not be loaded."
	
	var modsDir := Directory.new()
	var error = modsDir.change_dir("res://mods")
	if (error != OK):
		if GameManager.language == 0:
			printerr("Falha ao carregar a pasta de mods.")
		elif GameManager.language == 1:
			printerr("Failed to open the mods folder.")
		$ErrorText.visible = true
		return
		
	modsDir.list_dir_begin(true, true)
	var next_file := modsDir.get_next()
	while (next_file):
		if (next_file.get_extension() == "pck"):
			detectedMods.push_back(next_file)
			ProjectSettings.load_resource_pack("res://mods/" + next_file, true, 0)
		next_file = modsDir.get_next()
		
	var modInfo = ConfigFile.new()
	for i in detectedMods.size():
		var err = modInfo.load("res://modinfo.cfg")
		if err == OK: # If not, something went wrong with the file loading
			if GameManager.language == 0:
				print("Mods carregados com sucesso.")
			if GameManager.language == 1:
				print("Mods has been sucefully loaded.")
		else:
			if GameManager.language == 0:
				printerr("Não foi possível carregar os mods.")
			if GameManager.language == 1:
				printerr("Could not load the mods.")
			
		$modsList.add_item(detectedMods[i])
		$modsList.set_item_metadata(i, 
		{"titlePTBR" : modInfo.get_value("modinfo", "namePTBR", "Título não fornecido"),
		"titleEng" : modInfo.get_value("modinfo", "nameEng", "No title provided"),
		"descPTBR" : modInfo.get_value("modinfo", "descPTBR", "Descrição não fornecida"),
		"descEng" : modInfo.get_value("modinfo", "descEng", "No description provided"),
		"icon" : load("res://mods/" + detectedMods[i] + "/modIcon.png")})

func _process(delta):
	if !$modsList.get_selected_items().empty():
		$ActivateMod.disabled = false
		if !GameManager.loadedMods.empty():
			for i in GameManager.loadedMods.size():
				if $modsList.get_item_text($modsList.get_selected_items()[0]) == GameManager.loadedMods[i]:
					if GameManager.language == 0:
						$ActivateMod.text = "(Desativar)"
					if GameManager.language == 1:
						$ActivateMod.text = "(Deactivate)"
				else:
					if GameManager.language == 0:
						$ActivateMod.text = "Ativar"
					if GameManager.language == 1:
						$ActivateMod.text = "Activate"
		else:
			if GameManager.language == 0:
				$ActivateMod.text = "Ativar"
			if GameManager.language == 1:
				$ActivateMod.text = "Activate"
	else:
		$ActivateMod.disabled = true

func _on_modsList_item_selected(index):
	$modIcon.texture = $modsList.get_item_metadata(index)["icon"]
	if GameManager.language == 0:
		$modTitle.text = $modsList.get_item_metadata(index)["titlePTBR"]
		$modDesc.text = $modsList.get_item_metadata(index)["descPTBR"]
	if GameManager.language == 1:
		$modTitle.text = $modsList.get_item_metadata(index)["titleEng"]
		$modDesc.text = $modsList.get_item_metadata(index)["descEng"]
		
func _on_GoBack_pressed():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_ActivateMod_pressed():
	if !GameManager.loadedMods.empty():
		for i in GameManager.loadedMods.size():
			if !$modsList.get_item_text($modsList.get_selected_items()[0]) == GameManager.loadedMods[i]:
				GameManager.loadedMods.push_back($modsList.get_item_text($modsList.get_selected_items()[0]))
				
				load_modStages(false)
				load_modGuns(false)
			else:
				load_modStages(true)
				load_modGuns(true)
				GameManager.loadedMods.erase($modsList.get_item_text($modsList.get_selected_items()[0]))
	else:
		GameManager.loadedMods.push_back($modsList.get_item_text($modsList.get_selected_items()[0]))
		load_modStages(false)
		load_modGuns(false)

func load_modStages(removing : bool):
	for i in GameManager.loadedMods.size():
		var modStagesDir := Directory.new()
		var errorModStage = modStagesDir.change_dir("res://mods/" + GameManager.loadedMods[i] + "/scenes/runnables/stages")
		if (errorModStage != OK):
			if GameManager.language == 0:
				printerr("Falha ao carregar a pasta de níveis do mod " + GameManager.loadedMods[i] + ".")
			elif GameManager.language == 1:
				printerr("Failed to open the stages folder from the mod " + GameManager.loadedMods[i] + ".")
			return
			
		modStagesDir.list_dir_begin(true, true)
		var next_stageFile := modStagesDir.get_next()
		while (next_stageFile):
			if (next_stageFile.get_extension() == "tscn"):
				var loadedStage = load("res://mods/" + GameManager.loadedMods[i] + "/scenes/runnables/stages/" + next_stageFile)
				if !removing:
					if GameManager.stages.find(loadedStage, 0) == -1:
						GameManager.stages.push_back(loadedStage)
				else:
					if !GameManager.stages.find(loadedStage, 0) == -1:
						GameManager.stages.erase(loadedStage)
				
			next_stageFile = modStagesDir.get_next()
			
func load_modGuns(removing : bool):
	for i in GameManager.loadedMods.size():
		var modGunsDir := Directory.new()
		var errorModGun = modGunsDir.change_dir("res://mods/" + GameManager.loadedMods[i] + "/scenes/guns")
		if (errorModGun != OK):
			if GameManager.language == 0:
				printerr("Falha ao carregar a pasta de armas do mod " + GameManager.loadedMods[i] + ".")
			elif GameManager.language == 1:
				printerr("Failed to open the guns folder from the mod " + GameManager.loadedMods[i] + ".")
			return
			
		modGunsDir.list_dir_begin(true, true)
		var next_gunFile := modGunsDir.get_next()
		while (next_gunFile):
			if (next_gunFile.get_extension() == "tscn"):
				var loadedGun = load("res://mods/" + GameManager.loadedMods[i] + "/scenes/guns/" + next_gunFile)
				if !removing:
					if GameManager.guns.find(loadedGun, 0) == -1:
						GameManager.guns.push_back(loadedGun)
				else:
					if !GameManager.guns.find(loadedGun, 0) == -1:
						GameManager.guns.erase(loadedGun)
				
			next_gunFile = modGunsDir.get_next()
			
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
