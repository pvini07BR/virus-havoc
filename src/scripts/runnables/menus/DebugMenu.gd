extends Node2D

var howManyGuns = 0
var howManyStages = 0
var instanciatedGuns = []
var instanciatedStages = []
var music = preload("res://assets/music/menu_music.ogg")
var saveEquippedGunsFile = "user://equippedGuns.txt"

func _init():
	howManyGuns = 0

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
	
	get_tree().paused = false
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
	get_tree().get_root().get_node("GameManager/musicChannel").play()
	
	load_equippedGuns()
	
	while howManyGuns < GameManager.guns.size():
		instanciatedGuns.push_back(GameManager.guns.values()[howManyGuns].instance())
			
		$GunSelectSlot1.add_item(GameManager.guns.keys()[howManyGuns])
		$GunSelectSlot1.set_item_metadata(howManyGuns, GameManager.guns.values()[howManyGuns])
		$GunSelectSlot1.set_item_icon(howManyGuns, instanciatedGuns[howManyGuns].previewSprite)
			
		$GunSelectSlot2.add_item(GameManager.guns.keys()[howManyGuns])
		$GunSelectSlot2.set_item_metadata(howManyGuns, GameManager.guns.values()[howManyGuns])
		$GunSelectSlot2.set_item_icon(howManyGuns, instanciatedGuns[howManyGuns].previewSprite)
		
		if !GameManager.equippedGuns[0] == null:
			if GameManager.equippedGuns[0] == GameManager.guns.values()[howManyGuns]:
				$GunSelectSlot1.selected = howManyGuns
		else:
			$GunSelectSlot1.selected = $GunSelectSlot1.get_item_count() - 1
			
		if !GameManager.equippedGuns[1] == null:
			if GameManager.equippedGuns[1] == GameManager.guns.values()[howManyGuns]:
				$GunSelectSlot2.selected = howManyGuns
		else:
			$GunSelectSlot2.selected = $GunSelectSlot2.get_item_count() - 1
		howManyGuns += 1
	howManyGuns = 0
	
	while howManyStages < GameManager.stages.size():
		instanciatedStages.push_back(GameManager.stages.values()[howManyStages].instance())
		$LevelList.add_item(GameManager.stages.keys()[howManyStages])
		$LevelList.set_item_metadata(howManyStages, GameManager.stages.values()[howManyStages])
		howManyStages += 1
	howManyStages = 0
	$GunSelectSlot1.add_item("Nenhum")
	$GunSelectSlot2.add_item("Nenhum")
	if GameManager.equippedGuns[0] == null:
		$GunSelectSlot1.selected = $GunSelectSlot1.get_item_count() - 1
	if GameManager.equippedGuns[1] == null:
		$GunSelectSlot2.selected = $GunSelectSlot2.get_item_count() - 1
		
func _process(_delta):
	if GameManager.equippedGuns[0] == null and GameManager.equippedGuns[1] == null:
		$gunWarning.visible = true
	else:
		$gunWarning.visible = false
		if $GunSelectSlot1.selected == $GunSelectSlot2.selected:
			$GunSelectSlot2.selected = $GunSelectSlot2.get_item_count() - 1
	if GameManager.language == 0:
		$logo/logoText.text = "Versão de Acesso Antecipado!"
		$languageCheckBox.text = "Habilitar Idioma Inglês / Enable English Language"
		#$playButton.text = "Jogar (Nível 1)"
		$GunsListText.text = "Selecione sua(s) arma(s):"
		$GunSelectSlot1.set_item_text($GunSelectSlot1.get_item_count() - 1, "(Nenhum)")
		$GunSelectSlot2.set_item_text($GunSelectSlot1.get_item_count() - 1, "(Nenhum)")
		$gunWarning.text = "AVISO: VOCÊ ESTÁ SEM UMA ARMA EQUIPADA, LOGO NÃO PODERÁ ATIRAR!!!"
		$LevelListText.text = "Níveis disponíveis:"
		
		while howManyGuns < GameManager.guns.size():
			$GunSelectSlot1.set_item_text(howManyGuns, instanciatedGuns[howManyGuns].namePTBR)
			$GunSelectSlot2.set_item_text(howManyGuns, instanciatedGuns[howManyGuns].namePTBR)
			howManyGuns += 1
		howManyGuns = 0
		while howManyStages < GameManager.stages.size():
			$LevelList.set_item_text(howManyStages, instanciatedStages[howManyStages].namePTBR)
			howManyStages += 1
		howManyStages = 0
	if GameManager.language == 1:
		$logo/logoText.text = "Early Access Version!"
		$languageCheckBox.text = "Enable English Language / Habilitar Idioma Inglês"
		#$playButton.text = "Play (Stage 1)"
		$GunsListText.text = "Select your gun(s):"
		$GunSelectSlot1.set_item_text($GunSelectSlot1.get_item_count() - 1, "(Empty)")
		$GunSelectSlot2.set_item_text($GunSelectSlot1.get_item_count() - 1, "(Empty)")
		$gunWarning.text = "WARNING: YOU HAVEN'T EQUIPPED A GUN, SO YOU WON'T BE ABLE TO SHOOT!!!"
		$LevelListText.text = "Available Stages:"
		
		while howManyGuns < GameManager.guns.size():
			$GunSelectSlot1.set_item_text(howManyGuns, instanciatedGuns[howManyGuns].nameEng)
			$GunSelectSlot2.set_item_text(howManyGuns, instanciatedGuns[howManyGuns].nameEng)
			howManyGuns += 1
		howManyGuns = 0
		
		while howManyStages < GameManager.stages.size():
			$LevelList.set_item_text(howManyStages, instanciatedStages[howManyStages].nameEng)
			howManyStages += 1
		howManyStages = 0
		
	if $languageCheckBox.pressed:
		GameManager.language = 1
	else:
		GameManager.language = 0

#func _on_playButton_pressed():
	#GameManager.get_node("Fade").path = "res://scenes/runnables/stages/0_Stage1.tscn"
	#GameManager.get_node("Fade/layer/anim").play("fadeOut")
	
func _on_LevelList_item_selected(index):
	GameManager.get_node("Fade").path = GameManager.stages.values()[index]
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	GameManager.lastStagePlayed = index

func _on_GunSelectSlot1_item_selected(_index):
	if $GunSelectSlot1.selected == $GunSelectSlot1.get_item_count() - 1:
		GameManager.equippedGuns[0] = null
	else:
		GameManager.equippedGuns[0] = GameManager.guns.values()[$GunSelectSlot1.selected]
	save_equippedGuns(GameManager.equippedGuns)
	
func _on_GunSelectSlot2_item_selected(_index):
	if $GunSelectSlot2.selected == $GunSelectSlot2.get_item_count() - 1:
		GameManager.equippedGuns[1] = null
	else:
		GameManager.equippedGuns[1] = GameManager.guns.values()[$GunSelectSlot2.selected]
	save_equippedGuns(GameManager.equippedGuns)

func save_equippedGuns(content):
	var file = File.new()
	if (file.open("user://equippedGuns.txt", File.WRITE)== OK):
		if $GunSelectSlot1.selected == $GunSelectSlot1.get_item_count() - 1:
			file.store_line(to_json(null))
		else:
			file.store_line(to_json(str($GunSelectSlot1.selected)))
		if $GunSelectSlot2.selected == $GunSelectSlot2.get_item_count() - 1:
			file.store_line(to_json(null))
		else:
			file.store_line(to_json(str($GunSelectSlot2.selected)))
		file.close()
		
func load_equippedGuns():
	var file = File.new()
	if not file.file_exists("user://equippedGuns.txt"):
		return
	if (file.open("user://equippedGuns.txt", File.READ)== OK):
		var loadedSlot1 = (file.get_line())
		var loadedSlot2 = (file.get_line())
		file.close()
		
		if loadedSlot1 == "null":
			GameManager.equippedGuns[0] = null
		else:
			GameManager.equippedGuns[0] = GameManager.guns.values()[int(loadedSlot1)]
			
		if loadedSlot2 == "null":
			GameManager.equippedGuns[1] = null
		else:
			GameManager.equippedGuns[1] = GameManager.guns.values()[int(loadedSlot2)]
			
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
