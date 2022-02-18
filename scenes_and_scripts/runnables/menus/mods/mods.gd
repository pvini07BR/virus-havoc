extends Node2D

var music = preload("res://assets/music/menu.ogg")

var detectedMods = []
	
func _ready():
	if !get_tree().get_root().get_node("GameManager/musicChannel").stream == music:
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
		get_tree().get_root().get_node("GameManager/musicChannel").play()
	
	if GameManager.language == 0:
		$GoBack.text = "Voltar"
		$ErrorText.text = "A pasta de mods não pôde ser carregada."
	if GameManager.language == 1:
		$GoBack.text = "Go back"
		$ErrorText.text = "The mods folder could not be loaded."
	
	var modsDir := Directory.new()
	var error = modsDir.change_dir("mods")
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
		if modsDir.current_is_dir():
			detectedMods.push_back(next_file)
		next_file = modsDir.get_next()
		
	for i in detectedMods.size():
		var modInfo = ConfigFile.new()
		var err = modInfo.load("mods/" + detectedMods[i] + "/modinfo.cfg")
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
		"icon" : load("mods/" + detectedMods[i] + "/modIcon.png")})

func _process(delta):
	if !$modsList.get_selected_items().empty():
		$ActivateMod.disabled = false
		if !GameManager.loadedMods.empty():
			for i in GameManager.loadedMods.size():
				if $modsList.get_item_text($modsList.get_selected_items()[0]) == GameManager.loadedMods[i]:
					$ActivateMod.disabled = true
					if GameManager.language == 0:
						$ActivateMod.text = "(Ativado)"
					if GameManager.language == 1:
						$ActivateMod.text = "(Activated)"
				else:
					$ActivateMod.disabled = false
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
	GameManager.goto_scene(GameManager.menus["debug_menu"])

func _on_ActivateMod_pressed():
	var pck := Directory.new()
	var error = pck.open("mods/" + detectedMods[$modsList.get_selected_items()[0]] + "/")
	if (error != OK):
		return
		
	pck.list_dir_begin(true, true)
	var pckFile := pck.get_next()
	while (pckFile):
		if (pckFile.get_extension() == "pck"):
			ProjectSettings.load_resource_pack("mods/" + detectedMods[$modsList.get_selected_items()[0]] + "/" + pckFile, true)
			GameManager.loadGuns()
			GameManager.loadStages()
		pckFile = pck.get_next()
	
	if GameManager.loadedMods.empty():
		GameManager.loadedMods.append(detectedMods[$modsList.get_selected_items()[0]])
	
	#if !GameManager.loadedMods.empty():
		#for i in GameManager.loadedMods.size():
			#if !$modsList.get_item_text($modsList.get_selected_items()[0]) == GameManager.loadedMods[i]:
				#GameManager.loadedMods.push_back($modsList.get_item_text($modsList.get_selected_items()[0]))
				
				#load_modStages(false)
				#load_modGuns(false)
			#else:
				#load_modStages(true)
				#load_modGuns(true)
				#GameManager.loadedMods.erase($modsList.get_item_text($modsList.get_selected_items()[0]))
	#else:
		#GameManager.loadedMods.push_back($modsList.get_item_text($modsList.get_selected_items()[0]))
		#load_modStages(false)
		#load_modGuns(false)
			
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
