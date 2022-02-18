extends Node2D

var howManyStages = 0
var instanciatedStages = []
var music = preload("res://assets/music/menu.ogg")

func _ready():
	$logoBumpin.interpolate_property($logo/logoText, "rect_scale", Vector2(1,1), Vector2(1.1,1.1), 0.44, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$logoBumpin.interpolate_property($logo/logoText, "rect_scale", Vector2(1.1,1.1), Vector2(1,1), 0.2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT, 0.44)
	$logoBumpin.start()
	
	if GameManager.languageTemp == "en":
		$languageCheckBox.pressed = true
	else:
		$languageCheckBox.pressed = false
	
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	GameManager.itsAlreadyPaused = false
	
	if GameManager.wasInBossBattle == true:
		$bossEnableCheckBox.pressed = true
	elif !GameManager.wasInBossBattle:
		$bossEnableCheckBox.pressed = false
		
	if GameManager.platform == GameManager.PLATFORMS.MOBILE:
		$mobileModeCheckbox.pressed = true
	else:
		$mobileModeCheckbox.pressed = false
	
	get_tree().paused = false
	if !get_tree().get_root().get_node("GameManager/musicChannel").stream == music:
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
		get_tree().get_root().get_node("GameManager/musicChannel").play()
	
	for i in GameManager.stages.size():
		if !GameManager.stages.empty():
			instanciatedStages.push_back(GameManager.stages[i].instance())
			$LevelList.add_item("stage placeholder")
			$LevelList.set_item_metadata(i, GameManager.stages[i])
	
	$GunDexButton.rect_size.x = 0
	$ModsButton.rect_size.x = 0
	$settingsButton.rect_size.x = 0
		
func _process(_delta):
	if GameManager.language == 0:
		if !GameManager.stages.empty():
			for i in GameManager.stages.size():
				$LevelList.set_item_text(i, instanciatedStages[i].namePTBR)
				$LevelList.set_item_tooltip(i, instanciatedStages[i].descPTBR)
	if GameManager.language == 1:
		if !GameManager.stages.empty():
			for i in GameManager.stages.size():
					$LevelList.set_item_text(i, instanciatedStages[i].nameEng)
					$LevelList.set_item_tooltip(i, instanciatedStages[i].descEng)
		
	if $languageCheckBox.pressed:
		GameManager.languageTemp = "en"
		TranslationServer.set_locale(GameManager.languageTemp)
		$GunDexButton.rect_size.x = 0
	else:
		GameManager.languageTemp = "pt"
		TranslationServer.set_locale(GameManager.languageTemp)
		$GunDexButton.rect_size.x = 0
		
	if $bossEnableCheckBox.pressed:
		GameManager.wasInBossBattle = true
	else:
		GameManager.wasInBossBattle = false
		
	if $mobileModeCheckbox.pressed:
		GameManager.platform = GameManager.PLATFORMS.MOBILE
		$settingsButton.visible = true
		$settingsButton.disabled = false
	else:
		GameManager.platform = GameManager.PLATFORMS.PC
		$settingsButton.visible = false
		$settingsButton.disabled = true
	
func _on_LevelList_item_selected(index):
	GameManager.goto_scene(GameManager.stages[index])
	GameManager.lastStagePlayed = index

func _on_GunDexButton_pressed():
	GameManager.goto_scene(GameManager.menus["gundex"])

func _on_ModsButton_pressed():
	GameManager.goto_scene(GameManager.menus["mods"])

func _on_settingsButton_pressed():
	GameManager.goto_scene(GameManager.menus["touchscreen_ui_settings"])
