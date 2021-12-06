extends Node2D

class_name Bullet

var damage := 0

func _ready():
	add_to_group("projectile")
