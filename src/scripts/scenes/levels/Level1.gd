extends Node2D

onready var viruses = {
	commonVirus = preload("res://scenes/viruses/CommonVirus.tscn"),
	DualLaserVirus = preload("res://scenes/viruses/DualLaserVirus.tscn"),
	brokenVirus = preload("res://scenes/viruses/BrokenVirus.tscn"),
	dualDiagonalVirus = preload("res://scenes/viruses/DualDiagonalVirus.tscn"),
	rainbowVirus_Boss = preload("res://scenes/viruses/bosses/rainbowVirus.tscn")
}
var lootBox = preload("res://scenes/LootBox.tscn")
var lootBoxSpawningChance
var lootBoxSpawnOnce = false

var wave0 = false
var wave1 = false
var wave2 = false
var wave3 = false

var virusesKilled = 0
var score = 0
var bitcoins = 0
var isBossFight = false
var isBossFightTriggerOnce = false
var music = preload("res://assets/music/level1_music.ogg")
var bossMusic = preload("res://assets/music/unused/boss1Music_notRemixed.ogg")

func _ready():
	get_tree().paused = false
	
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
	get_tree().get_root().get_node("GameManager/musicChannel").play()
	if !isBossFight:
		if !wave0:
			$virusSpawningTimer.start()
			wave0 = true

func _process(_delta):
	if !isBossFight:
		if virusesKilled == 20 and !wave1:
			calculate_LootBoxProbab()
			if lootBoxSpawningChance >= 2:
				add_child(lootBox.instance())
			$virusSpawningTimer2.start()
			wave1 = true
		if virusesKilled == 40 and !wave2:
			$virusSpawningTimer3.start()
			wave2 = true
			
		if virusesKilled == 50 and !wave3:
			calculate_LootBoxProbab()
			if lootBoxSpawningChance >= 2:
				add_child(lootBox.instance())
			$virusSpawningTimer4.start()
			wave3 = true
	if virusesKilled >= 60 and !isBossFight:
		isBossFight = true
		
	bitcoins = score / 6
	if bitcoins <= 0:
		bitcoins = 0
		
	if isBossFight == true:
		if !isBossFightTriggerOnce:
			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(bossMusic)
			get_tree().get_root().get_node("GameManager/musicChannel").play()
			add_child(viruses.rainbowVirus_Boss.instance())
			isBossFightTriggerOnce = true
		
func _on_virusSpawningTimer_timeout():
	if !isBossFight:
		add_child(viruses.commonVirus.instance())

func _on_virusSpawningTimer2_timeout():
	if !isBossFight:
		add_child(viruses.DualLaserVirus.instance())

func _on_virusSpawningTimer3_timeout():
	if !isBossFight:
		add_child(viruses.brokenVirus.instance())

func _on_virusSpawningTimer4_timeout():
	if !isBossFight:
		add_child(viruses.dualDiagonalVirus.instance())
		
func calculate_LootBoxProbab():
	randomize()
	lootBoxSpawningChance = [1, 2, 3][randi() % 3]
