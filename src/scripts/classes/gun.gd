extends Node2D

class_name Gun

export(PackedScene) var projectile
export(Texture) var previewSprite
export(String) var namePTBR
export(String) var nameEng
export(String) var descPTBR
export(String) var descEng
export(float) var damage
export(AudioStreamSample) var shootingSound
var gunNotFoundSprite : Texture = preload("res://assets/images/guns/preview/gunPreview_gunNotFound.png")
var nameNotFoundPTBR : String = "(Não há nome)"
var nameNotFoundEng : String = "(No name provided)"
var descNotFoundPTBR : String = "(Não há descrição)"
var descNotFoundEng : String = "(No description provided)"
var cooldown = false
var rng = RandomNumberGenerator.new()
var active = false

func _ready():
	z_index = 2
	z_as_relative = false
	
func _process(delta):
	if active:
		visible = true
	else:
		visible = false
