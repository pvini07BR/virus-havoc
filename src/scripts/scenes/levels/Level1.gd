extends Node2D

onready var viruses = {
	commonVirus = preload("res://scenes/viruses/CommonVirus.tscn"),
	DualLaserVirus = preload("res://scenes/viruses/DualLaserVirus.tscn"),
	brokenVirus = preload("res://scenes/viruses/BrokenVirus.tscn"),
	dualDiagonalVirus = preload("res://scenes/viruses/DualDiagonalVirus.tscn"),
	rainbowVirus_Boss = preload("res://scenes/viruses/bosses/rainbowVirus.tscn")
}
var virusesKilled = 0
var score = 0
var bitcoins = 0
var isBossFight = false
var isBossFightTriggerOnce = false
export (AudioStream) var bossMusic = preload("res://assets/music/unused/boss1Music_notRemixed.ogg")

func _ready():
	if !isBossFight:
		$virusSpawningTimer.start()

func _process(_delta):
	if !isBossFight:
		if virusesKilled <= 20:
			$virusSpawningTimer2.start()
		if virusesKilled <= 40:
			$virusSpawningTimer3.start()
		if virusesKilled <= 50:
			$virusSpawningTimer4.start()
	if virusesKilled >= 60:
		isBossFight = true
		
	bitcoins = score / 6
	if bitcoins <= 0:
		bitcoins = 0
		
	$CanvasLayer/playerHealth.text = ("Health: %d" % $player.hp)
	$CanvasLayer/playerHealth/virusesKilled.text = ("Killed: %d" % virusesKilled)
	if GameManager.language == 0:
		$CanvasLayer/gunEquipped.text = (get_tree().get_nodes_in_group("gun")[0].namePTBR)
	elif GameManager.language == 1:
		$CanvasLayer/gunEquipped.text = (get_tree().get_nodes_in_group("gun")[0].nameEng)
	$CanvasLayer/score.text = ("Score: %d" % score)
	$CanvasLayer/score/bitcoins.text = ("Bitcoins Earned: %d" % bitcoins)
		
	$CanvasLayer/gunEquipped/gunPreview.texture = get_tree().get_nodes_in_group("gun")[0].previewSprite
	
	if isBossFight == true:
		if !isBossFightTriggerOnce:
			$BackgroundMusic.set_stream(bossMusic)
			$BackgroundMusic.play()
			$CanvasLayer/bossHealth.visible = true
			add_child(viruses.rainbowVirus_Boss.instance())
			isBossFightTriggerOnce = true
		$CanvasLayer/bossHealth.text = ("Boss: %d" % get_node("rainbowVirus").health)
		
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
