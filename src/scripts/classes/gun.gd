extends Node2D

class_name Gun

export(PackedScene) var projectile
export(Texture) var previewSprite
export(String) var gunName
export(String) var gunDesc
export(float) var damage
export(AudioStreamSample) var shootingSound
var gunNotFoundSprite : Texture = preload("res://assets/images/guns/preview/gunPreview_gunNotFound.png")
var cooldown = false
var rng = RandomNumberGenerator.new()
var active = false

func _init():
	if gunName == null or gunName == "":
		gunName = "GUNDEX_NAME_NOT_FOUND"
		
	if gunDesc == null or gunDesc == "":
		gunDesc = "GUNDEX_DESC_NOT_FOUND"
	
	if previewSprite == null:
		previewSprite = gunNotFoundSprite

func _ready():
	z_index = 2
	z_as_relative = false
	
func _process(delta):
	if active:
		visible = true
	else:
		visible = false
