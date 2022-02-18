extends Virus

var randomX
var randomY
var distanceX
var distanceY

var pointing = false

func _init():
	rng.randomize()
	randomX = rng.randf_range(640, 960)
	randomY = rng.randf_range(50, 666)

func _ready():
	rng.randomize()
	$shootingDaBeam.wait_time = rng.randf_range(3, 5)
	$movemente.interpolate_property(self, "position", Vector2(1310, randomY), Vector2(randomX, randomY), rng.randf_range(1,4))
	$movemente.start()
	yield($movemente,"tween_all_completed")
	$shootingDaBeam.start()
	pointing = true
	
func _process(delta):
	if pointing == true:
		var dir = (get_parent().get_node("player").global_position - global_position).normalized()
		global_rotation = dir.angle() + PI
		$Line2D.visible = true
	else:
		$Line2D.visible = false

func _on_shootingDaBeam_timeout():
	pointing = false
	$anim.play("opening")
	yield($anim,"animation_finished")
	add_child(projectile.instance())
	yield(get_tree().create_timer(1.5), "timeout")
	$anim.play("trashBinDeath")

func _on_anim_animation_finished(anim_name):
	if anim_name == "trashBinDeath":
		queue_free()
