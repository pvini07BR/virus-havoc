extends Node2D

class_name Stage

onready var player = preload("res://scenes_and_scripts/entities/player/Player.tscn")
onready var playerInst
onready var UI = preload("res://scenes_and_scripts/components/stage/LevelUI.tscn")
onready var UInst
onready var TouchUI
onready var TouchUInst
onready var barrier = preload("res://scenes_and_scripts/components/stage/barrier.tscn")
onready var lootBox = preload("res://scenes_and_scripts/entities/pickups/LootBox/LootBox.tscn")
onready var gameOver = preload("res://scenes_and_scripts/runnables/menus/GameOverScreen/GameOverScreen.tscn")
onready var pauseUI = preload("res://scenes_and_scripts/components/stage/PauseUI.tscn")
onready var finishedUI = preload("res://scenes_and_scripts/components/stage/LevelFinishedUI.tscn")
onready var gunReplacementUI = preload("res://scenes_and_scripts/components/stage/GunReplacingUI.tscn")

onready var victoryMusic = preload("res://assets/music/victoryTheme.ogg")

export(String) var namePTBR
export(String) var nameEng
export(String) var titlePTBR
export(String) var titleEng
export(String) var descPTBR
export(String) var descEng
export(Texture) var previewSprite
export(AudioStreamOGGVorbis) var music
export(AudioStreamOGGVorbis) var bossMusic
export(PackedScene) var boss 
export(Array, PackedScene) var viruses = viruses as Virus
export(Array, PackedScene) var GunsInLootBox = GunsInLootBox as Gun
export(PackedScene) var background

signal stage_started
signal stage_ended

var gunSwitchingSound = preload("res://assets/sounds/gunEquip.wav")
var gunSwitchingStreamPlayer := AudioStreamPlayer.new()

var virusesKilled = 0
var score = 0
var bitcoins = 0
var isBossFight = false
var isBossFightTriggerOnce = false
var obtainedLootBoxBefore = false
var inputWorking = false
var lootBoxSpawningChance = 0

var stageBegun = false
var stageFinished = false

var guns : Array
var gunIndex := 0

var bossInst
var camera : Camera2D

func _init():
	gunSwitchingStreamPlayer.stream = gunSwitchingSound
	if !GameManager.wasInBossBattle:
		GameManager.load_equippedGuns()
	if GameManager.wasInBossBattle == true:
		score = GameManager.storedScore
		bitcoins = GameManager.storedBitcoins
		virusesKilled = GameManager.storedKills

func _ready():
	if GameManager.platform == GameManager.PLATFORMS.MOBILE:
		TouchUI = preload("res://scenes_and_scripts/components/stage/StageTouchscreenUI/StageTouchscreenUI.tscn")
	
	add_child(gunSwitchingStreamPlayer)
	guns.resize(GameManager.equippedGuns.size())
	for i in GameManager.equippedGuns.size():
		if !GameManager.equippedGuns[i] == null:
			guns[i] = GameManager.equippedGuns[i].instance()
			
	while guns[gunIndex] == null:
		gunIndex += 1
	guns[gunIndex].active = true
	
	add_to_group("stage")
	
	connect("stage_started", self, "_on_stage_started")
	connect("stage_ended", self, "_on_stage_ended")
	
	playerInst = player.instance()
	connect("stage_ended", playerInst, "_on_stage_ended")
	if GameManager.wasInBossBattle == true:
		playerInst.position.x = 213
		playerInst.position.y = 360
	else:
		playerInst.position.x = -70
		playerInst.position.y = 360
	add_child(playerInst)
	for i in guns:
		if !i == null:
			playerInst.gunsHandler.add_child(i)
	if !boss == null:
		bossInst = boss.instance()
	
	get_tree().paused = false
	
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
	UInst = UI.instance()
	connect("stage_started", UInst, "_on_stage_started")
	connect("stage_ended", UInst, "_on_stage_ended")
	add_child(UInst)
	
	if GameManager.platform == GameManager.PLATFORMS.MOBILE:
		TouchUInst = TouchUI.instance()
		connect("stage_started", TouchUInst, "_on_stage_started")
		connect("stage_ended", TouchUInst, "_on_stage_ended")
		add_child(TouchUInst)
	
	if !background == null:
		add_child(background.instance())
	
	camera = Camera2D.new()
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	camera.current = true
	add_child(camera)
	
	if !GameManager.wasInBossBattle:
		camera.zoom = Vector2(0.3,0.3)
		camera.offset = Vector2(40,256)
		var playerEntrance = Tween.new()
		add_child(playerEntrance)
		playerEntrance.interpolate_property(playerInst, "position", Vector2(-200,360), Vector2(213,360),1.5,Tween.EASE_OUT)
		playerEntrance.start()
		yield(playerEntrance,"tween_all_completed")
		var cameraZoomingOut = Tween.new()
		var cameraZoomingOut2 = Tween.new()
		cameraZoomingOut.interpolate_property(camera, "zoom", camera.zoom, Vector2(1,1), 1, Tween.TRANS_CIRC)
		cameraZoomingOut2.interpolate_property(camera, "offset", camera.offset, Vector2(0,0),1,Tween.TRANS_CIRC)
		add_child(cameraZoomingOut)
		add_child(cameraZoomingOut2)
		cameraZoomingOut.start()
		cameraZoomingOut2.start()
		yield(cameraZoomingOut,"tween_all_completed")
		beginStage()
	else:
		camera.zoom = Vector2(1,1)
		camera.offset = Vector2(0,0)
		stageBegun = true
		inputWorking = true
	
	add_child(barrier.instance())
	
	if GameManager.wasInBossBattle == true:
		startBossFight()
	
func _input(event):
	if inputWorking == true:
		if Input.is_action_just_pressed("ui_selectWeapon0"):
			if gunIndex > 0:
				if !guns[gunIndex - 1] == null:
					var prevIndex = gunIndex
					guns[prevIndex].active = false
					gunIndex -= 1
					gunIndex = clamp(gunIndex, 0, guns.size() - 1)
					guns[gunIndex].active = true
					gunSwitchingStreamPlayer.play()
		if Input.is_action_just_pressed("ui_selectWeapon1"):
			if gunIndex < guns.size() - 1:
				if !guns[gunIndex + 1] == null:
					var prevIndex = gunIndex
					guns[prevIndex].active = false
					gunIndex += 1
					gunIndex = clamp(gunIndex, 0, guns.size() - 1)
					guns[gunIndex].active = true
					gunSwitchingStreamPlayer.play()
		if Input.is_action_just_pressed("ui_cancel"):
			add_child(pauseUI.instance())
	
func _process(_delta):
	if score >= 0:
		bitcoins = score / 6
	if bitcoins < 0:
		bitcoins = 0
		
	if playerInst.hp <= 0:
		GameManager.goto_scene(gameOver)
	
func spawnLootBox(force : bool):
	if force == false:
		if !obtainedLootBoxBefore:
			randomize()
			lootBoxSpawningChance = [1, 2, 3][randi() % 3]
			if lootBoxSpawningChance >= 2:
				add_child(lootBox.instance())
	if force == true:
		add_child(lootBox.instance())
		
func gotLootBox(lootBox):
	var decided = lootBox.decidedGun
	var hasEmptySlot = false
	for i in guns.size():
		if guns[i] == null:
			hasEmptySlot = true
			guns[gunIndex].active = false
			guns[i] = decided.instance()
			playerInst.gunsHandler.add_child(guns[i])
			gunIndex = clamp(i, 0, guns.size() - 1)
			guns[gunIndex].active = true
			gunSwitchingStreamPlayer.play()
			break
	if !hasEmptySlot:
		var alreadyHasTheGun = false
		for i in guns.size():
			if GameManager.equippedGuns[i] == decided:
				alreadyHasTheGun = true
				guns[gunIndex].active = false
				gunIndex = clamp(i, 0, guns.size() - 1)
				guns[gunIndex].active = true
				gunSwitchingStreamPlayer.play()
		if !alreadyHasTheGun:
			var uinstace = gunReplacementUI.instance()
			uinstace.newGun = decided
			add_child(uinstace)
			
func replaceGun(index : int, gun):
	guns[gunIndex].active = false
	guns[index].queue_free()
	guns[index] = gun.instance()
	playerInst.gunsHandler.add_child(guns[index])
	gunIndex = clamp(index, 0, guns.size() - 1)
	guns[gunIndex].active = true
	gunSwitchingStreamPlayer.play()

func startBossFight():
	isBossFight = true
	GameManager.storedBitcoins = bitcoins
	GameManager.storedKills = virusesKilled
	GameManager.storedScore = score
	isBossFightTriggerOnce = true
	
	if !GameManager.wasInBossBattle:
		var musicFadeOut = Tween.new()
		musicFadeOut.connect("tween_all_completed", self, "_on_musicFadeOut_finished")
		musicFadeOut.interpolate_property(get_tree().get_root().get_node("GameManager/musicChannel"), "volume_db", 0, -80, 1)
		add_child(musicFadeOut)
		musicFadeOut.start()
	else:
		startBossFight2()
	GameManager.wasInBossBattle = true
	
func _on_musicFadeOut_finished():
	startBossFight2()
	
func startBossFight2():
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	get_tree().get_root().get_node("GameManager/musicChannel").volume_db = 0
	if !bossMusic == null:
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(bossMusic)
		get_tree().get_root().get_node("GameManager/musicChannel").play()
	if !boss == null:
		add_child(bossInst)
	
func endStage():
	if !stageFinished:
		emit_signal("stage_ended")
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		inputWorking = false
		var victoryMusicPlayer = AudioStreamPlayer.new()
		victoryMusicPlayer.stream = victoryMusic
		add_child(victoryMusicPlayer)
		victoryMusicPlayer.play()
		GameManager.save_equippedGuns(true)
		stageFinished = true
		yield(victoryMusicPlayer,"finished")
		add_child(finishedUI.instance())
		
func beginStage():
	if !stageBegun:
		inputWorking = true
		if !music == null:
			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
			get_tree().get_root().get_node("GameManager/musicChannel").play()
		emit_signal("stage_started")
		stageBegun = true
