extends Node2D

export var projectile: PackedScene
export var previewSprite: Texture
export var namePTBR: String
export var nameEng: String
export var damage: float
export var shootingSound: AudioStreamSample
var cooldown = false
var rng = RandomNumberGenerator.new()

func _ready():
	position = get_node("../gunPos").position
	
	z_index = 2
	z_as_relative = false