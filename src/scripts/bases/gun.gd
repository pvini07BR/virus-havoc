extends Node2D

export var projectile: PackedScene
export var previewSprite: Texture
export var namePTBR: String
export var nameEng: String
export var descPTBR : String
export var descEng : String
export var damage: float
export var shootingSound: AudioStreamSample
var gunNotFoundSprite : Texture = preload("res://assets/images/guns/preview/gunPreview_gunNotFound.png")
var nameNotFoundPTBR : String = "(Não há nome)"
var nameNotFoundEng : String = "(No name provided)"
var descNotFoundPTBR : String = "(Não há descrição)"
var descNotFoundEng : String = "(No description provided)"
var shootingPlayer = AudioStreamPlayer.new()
var cooldown = false
var rng = RandomNumberGenerator.new()
var active = false

func _ready():
	if !shootingSound == null:
		shootingPlayer.stream = shootingSound
		shootingPlayer.volume_db = -10
		add_child(shootingPlayer)
	
	position = get_node("../gunPos").position
	
	z_index = 2
	z_as_relative = false
