extends Node2D

var howManyStages = 0
var instanciatedStages = []
var music = preload("res://assets/music/menu.ogg")

func _ready():
	$logoBumpin.interpolate_property($logo/logoText, "rect_scale", Vector2(1,1), Vector2(1.1,1.1), 0.44, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$logoBumpin.interpolate_property($logo/logoText, "rect_scale", Vector2(1.1,1.1), Vector2(1,1), 0.2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT, 0.44)
	$logoBumpin.start()
	
	if GameManager.language == 1:
		$languageCheckBox.pressed = true
	elif GameManager.language == 0:
		$languageCheckBox.pressed = false
	
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	
	if GameManager.wasInBossBattle == true:
		$bossEnableCheckBox.pressed = true
	elif !GameManager.wasInBossBattle:
		$bossEnableCheckBox.pressed = false
	
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
		
func _process(_delta):
	if GameManager.language == 0:
		$logo/logoText.text = "Versão de Acesso Antecipado!"
		$languageCheckBox.text = "Habilitar Idioma Inglês / Enable English Language"
		$bossEnableCheckBox.text = "Começar boss fight logo ao iniciar um nível"
		$LevelListText.text = "Níveis disponíveis:"
	
		if !GameManager.stages.empty():
			for i in GameManager.stages.size():
				$LevelList.set_item_text(i, instanciatedStages[i].namePTBR)
				$LevelList.set_item_tooltip(i, instanciatedStages[i].descPTBR)
	if GameManager.language == 1:
		$logo/logoText.text = "Early Access Version!"
		$languageCheckBox.text = "Enable English Language / Habilitar Idioma Inglês"
		$bossEnableCheckBox.text = "Start boss fight when starting a stage"
		$LevelListText.text = "Available Stages:"
		
		if !GameManager.stages.empty():
			for i in GameManager.stages.size():
					$LevelList.set_item_text(i, instanciatedStages[i].nameEng)
					$LevelList.set_item_tooltip(i, instanciatedStages[i].descEng)
		
	if $languageCheckBox.pressed:
		GameManager.language = 1
	else:
		GameManager.language = 0
		
	if $bossEnableCheckBox.pressed:
		GameManager.wasInBossBattle = true
	else:
		GameManager.wasInBossBattle = false
	
func _on_LevelList_item_selected(index):
	GameManager.get_node("Fade").path = GameManager.stages[index]
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	GameManager.lastStagePlayed = index
			
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false

func _on_GunDexButton_pressed():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/Gundex.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_ModsButton_pressed():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/mods.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
