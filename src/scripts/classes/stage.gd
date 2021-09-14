extends Node2D

class_name Stage

onready var player = preload("res://scenes/Player.tscn")
onready var playerInst
onready var UI = preload("res://scenes/LevelUI.tscn")
onready var UInst
onready var barrier = preload("res://scenes/barrier.tscn")
onready var pause = preload("res://scenes/pause.tscn")
onready var lootBox = preload("res://scenes/LootBox.tscn")
onready var gameOver = preload("res://scenes/runnables/menus/GameOverScreen.tscn")

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
export(Array) var viruses = viruses as Virus
export(Array) var GunsInLootBox = GunsInLootBox as Gun
export(PackedScene) var background

signal stage_started

var gunSwitchingSound = preload("res://assets/sounds/gunEquip.wav")
var gunSwitchingStreamPlayer := AudioStreamPlayer.new()

var virusesKilled = 0
var score = 0
var bitcoins = 0
var isBossFight = false
var isBossFightTriggerOnce = false
var obtainedLootBoxBefore = false
var lootBoxSpawningChance = 0

var stageBegun = false
var stageFinished = false

var guns : Array
var gunIndex := 0

var bossInst
var camera

func _init():
	gunSwitchingStreamPlayer.stream = gunSwitchingSound
	if !GameManager.wasInBossBattle:
		GameManager.load_equippedGuns()
	if GameManager.wasInBossBattle == true:
		score = GameManager.storedScore
		bitcoins = GameManager.storedBitcoins
		virusesKilled = GameManager.storedKills

func _ready():
	add_child(gunSwitchingStreamPlayer)
	for i in GameManager.equippedGuns.size():
		if !GameManager.equippedGuns[i] == null:
			guns.resize(i + 1)
			guns[i] = GameManager.equippedGuns[i].instance()
	guns[gunIndex].active = true
	
	add_to_group("stage")
	
	connect("stage_started", self, "_on_stage_started")
	
	playerInst = player.instance()
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
	
	if !background == null:
		add_child(background.instance())
	
	if !GameManager.wasInBossBattle:
		var playerEntrance = Tween.new()
		playerEntrance.connect("tween_all_completed", self, "_on_playerEntrance_completed")
		add_child(playerEntrance)
		playerEntrance.interpolate_property(playerInst, "position", Vector2(-200,360), Vector2(213,360),1.5,Tween.EASE_OUT)
		playerEntrance.start()
	else:
		stageBegun = true
		playerInst.isInputWorking = true
	
	UInst = UI.instance()
	add_child(UInst)
	
	add_child(barrier.instance())
	add_child(pause.instance())
	
	camera = Camera2D.new()
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	camera.current = true
	if GameManager.wasInBossBattle == true:
		camera.zoom = Vector2(1,1)
		camera.offset = Vector2(0,0)
	else:
		camera.zoom = Vector2(0.3,0.3)
		camera.offset = Vector2(40,256)
	add_child(camera)
	
	if GameManager.wasInBossBattle == true:
		startBossFight()
	
func _input(event):
	if Input.is_action_just_pressed("ui_selectWeapon0"):
		if gunIndex > 0:
			var prevIndex = gunIndex
			guns[prevIndex].active = false
			gunIndex -= 1
			gunIndex = clamp(gunIndex, 0, guns.size() - 1)
			guns[gunIndex].active = true
			gunSwitchingStreamPlayer.play()
	if Input.is_action_just_pressed("ui_selectWeapon1"):
		if gunIndex < guns.size() - 1:
			var prevIndex = gunIndex
			guns[prevIndex].active = false
			gunIndex += 1
			gunIndex = clamp(gunIndex, 0, guns.size() - 1)
			guns[gunIndex].active = true
			gunSwitchingStreamPlayer.play()
	
func _process(_delta):
	if score >= 0:
		bitcoins = score / 6
	if bitcoins < 0:
		bitcoins = 0
		
	if playerInst.hp <= 0:
		GameManager.goto_scene(gameOver)
	
func spawnLootBox():
	if !obtainedLootBoxBefore:
		randomize()
		lootBoxSpawningChance = [1, 2, 3][randi() % 3]
		if lootBoxSpawningChance >= 2:
			add_child(lootBox.instance())
			
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
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		playerInst.isInputWorking = false
		var victoryMusicPlayer = AudioStreamPlayer.new()
		victoryMusicPlayer.stream = victoryMusic
		victoryMusicPlayer.connect("finished", self, "_on_VictoryMusic_finished")
		add_child(victoryMusicPlayer)
		victoryMusicPlayer.play()
		GameManager.save_equippedGuns(true)
		stageFinished = true
		
func beginStage():
	if !stageBegun:
		playerInst.isInputWorking = true
		if !music == null:
			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
			get_tree().get_root().get_node("GameManager/musicChannel").play()
		emit_signal("stage_started")
		stageBegun = true
	
func _on_VictoryMusic_finished():
	UInst.makeLevelFinishedAppear()
	
func _on_playerEntrance_completed():
	var cameraZoomingOut = Tween.new()
	var cameraZoomingOut2 = Tween.new()
	cameraZoomingOut.connect("tween_all_completed", self, "_on_cameraZoomingOut_completed")
	cameraZoomingOut.interpolate_property(camera, "zoom", camera.zoom, Vector2(1,1), 1, Tween.TRANS_CIRC)
	cameraZoomingOut2.interpolate_property(camera, "offset", camera.offset, Vector2(0,0),1,Tween.TRANS_CIRC)
	add_child(cameraZoomingOut)
	add_child(cameraZoomingOut2)
	cameraZoomingOut.start()
	cameraZoomingOut2.start()
		
func _on_cameraZoomingOut_completed():
	beginStage()
