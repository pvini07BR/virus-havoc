extends Node2D

onready var player = preload("res://scenes/Player.tscn")
onready var UI = preload("res://scenes/LevelUI.tscn")
onready var barrier = preload("res://scenes/barrier.tscn")
onready var pause = preload("res://scenes/pause.tscn")
onready var lootBox = preload("res://scenes/LootBox.tscn")

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

var stageFinished = false

var bossInst

func _init():
	if !GameManager.wasInBossBattle:
		load_equippedGuns()
	if GameManager.wasInBossBattle == true:
		score = GameManager.storedScore
		bitcoins = GameManager.storedBitcoins
		virusesKilled = GameManager.storedKills

func _ready():
	bossInst = boss.instance()
	
	get_tree().paused = false

	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
	get_tree().get_root().get_node("GameManager/musicChannel").play()
	
	add_child(background.instance())
	
	var playerInst = player.instance()
	playerInst.position.x = 213
	playerInst.position.y = 360
	add_child(playerInst)
	
	add_child(UI.instance())
	
	add_child(barrier.instance())
	add_child(pause.instance())
	
	if GameManager.wasInBossBattle == true:
		startBossFight()
	
func _process(delta):
	if bossInst.health <= 0 and !stageFinished:
		endStage()
		
	bitcoins = score / 6
	if bitcoins <= 0:
		bitcoins = 0
	
func spawnLootBox():
	if !obtainedLootBoxBefore:
		randomize()
		lootBoxSpawningChance = [1, 2, 3][randi() % 3]
		if lootBoxSpawningChance >= 2:
			add_child(lootBox.instance())
		
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
			
func startBossFight():
	isBossFight = true
	GameManager.wasInBossBattle = true
	GameManager.storedBitcoins = bitcoins
	GameManager.storedKills = virusesKilled
	GameManager.storedScore = score
	isBossFightTriggerOnce = true
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(bossMusic)
	get_tree().get_root().get_node("GameManager/musicChannel").play()
	add_child(bossInst)
	
func endStage():
	if !stageFinished:
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		var timer = Timer.new()
		timer.wait_time = 5
		timer.connect("timeout",self,"_on_timer_timeout") 
		add_child(timer)
		timer.start()
		stageFinished = true
	
func _on_timer_timeout():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
