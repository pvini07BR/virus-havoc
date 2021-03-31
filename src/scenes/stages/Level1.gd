extends Node2D

onready var commonVirus = preload("res://scenes/viruses/CommonVirus.tscn")
onready var DualLaserVirus = preload("res://scenes/viruses/DualLaserVirus.tscn")
var virusesKilled = 0
var round2 = false
onready var virusSpawningTimer = $virusSpawningTimer
onready var virusSpawningTimer2 = $virusSpawningTimer2


# Called when the node enters the scene tree for the first time.
func _ready():
	virusSpawningTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if virusesKilled <= 20:
		virusSpawningTimer2.start()


func _on_virusSpawningTimer_timeout():
	add_child(commonVirus.instance())


func _on_virusSpawningTimer2_timeout():
	add_child(DualLaserVirus.instance())
