extends Area2D

class_name Bullet

export var isEnemy : bool

var damage := 0

func _ready():
	if isEnemy:
		add_to_group("virusBullet")
	else:
		add_to_group("projectile")
