extends Node2D

onready var player = preload("res://scenes/Player.tscn")
onready var playerInst
onready var UI = preload("res://scenes/LevelUI.tscn")
onready var UInst
onready var barrier = preload("res://scenes/barrier.tscn")
onready var pause = preload("res://scenes/pause.tscn")
onready var lootBox = preload("res://scenes/LootBox.tscn")

onready var victoryMusic = preload("res://assets/music/victoryTheme.ogg")

export var namePTBR : String
export var nameEng : String
export var titlePTBR : String
export var titleEng : String
export var descPTBR : String
export var descEng : String
export var previewSprite : Texture
export var music: AudioStreamOGGVorbis
export var bossMusic: AudioStreamOGGVorbis
export var boss : PackedScene
export var viruses : Array
export var background : PackedScene

var virusesKilled = 0
var score = 0
var bitcoins = 0
var isBossFight = false
var isBossFightTriggerOnce = false
var obtainedLootBoxBefore = false
var lootBoxSpawningChance = 0

var stageBegun = false
var stageFinished = false

var bossInst
var camera

func _init():
	if !GameManager.wasInBossBattle:
		GameManager.load_equippedGuns()
	if GameManager.wasInBossBattle == true:
		score = GameManager.storedScore
		bitcoins = GameManager.storedBitcoins
		virusesKilled = GameManager.storedKills

func _ready():
	if !boss == null:
		bossInst = boss.instance()
	
	get_tree().paused = false
	
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
	if !background == null:
		add_child(background.instance())
	
	playerInst = player.instance()
	if GameManager.wasInBossBattle == true:
		playerInst.position.x = 213
		playerInst.position.y = 360
	else:
		playerInst.position.x = -70
		playerInst.position.y = 360
	add_child(playerInst)
	
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
	
func _process(_delta):
	if score >= 0:
		bitcoins = score / 6
	if bitcoins < 0:
		bitcoins = 0
	
func spawnLootBox():
	if !obtainedLootBoxBefore:
		randomize()
		lootBoxSpawningChance = [1, 2, 3][randi() % 3]
		if lootBoxSpawningChance >= 2:
			add_child(lootBox.instance())
			
func startBossFight():
	isBossFight = true
	GameManager.wasInBossBattle = true
	GameManager.storedBitcoins = bitcoins
	GameManager.storedKills = virusesKilled
	GameManager.storedScore = score
	isBossFightTriggerOnce = true
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
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
		stageFinished = true
		
func beginStage():
	if !stageBegun:
		playerInst.isInputWorking = true
		if !music == null:
			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
			get_tree().get_root().get_node("GameManager/musicChannel").play()
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
