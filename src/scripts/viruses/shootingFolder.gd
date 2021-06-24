extends "res://scripts/bases/virus.gd"

var randomX
var randomY
var paper
var paperExists = false

func _init():
	rng.randomize()
	randomX = rng.randf_range(640, 960)
	randomY = rng.randf_range(50, 666)

func _ready():
	$movemente.interpolate_property(self, "position", Vector2(1310, randomY), Vector2(randomX, randomY), rng.randf_range(1,4))
	$movemente.start()

func _on_movemente_tween_all_completed():
	shoot()

func _on_shootingTimer_timeout():
	if !paper == null and paperExists == true:
		paper.shoot()
		paper = null
		paperExists = false
		shoot()
		
func shoot():
	paper = projectile.instance()
	paper.z_index = 1
	add_child(paper)
	$shootingTimer.start()
	paperExists = true
