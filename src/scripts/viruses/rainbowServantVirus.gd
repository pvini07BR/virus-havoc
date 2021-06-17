extends "res://scripts/bases/virus.gd"

var timesShooted = 0
var finishedOnce = false
var randomPos
var randomY
var randomX

func _init():
	randomize()
	maxHealth = [4,5][randi() % 2]
	randomPos = [0,1][randi() % 2]
	rng.randomize()
	randomX = rng.randf_range(480, 960)
	if randomPos == 0:
		randomY = rng.randf_range(50, 105)
	if randomPos == 1:
		randomY = rng.randf_range(590, 666)

func _ready():
	z_index = 5
	z_as_relative = false
	
	rng.randomize()
	$tripleShootingTimer.wait_time = rng.randf_range(0.3, 0.5)
	
	$moving.interpolate_property(self, "position", Vector2(1310, randomY), Vector2(randomX, randomY), rng.randf_range(1,4))
	$moving.start()
	
	$rotating.interpolate_property($Sprite, "rotation_degrees", 0, 360, 1)
	$rotating.start()
	
	$rainbow.interpolate_property($Sprite.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbow.start()
	
	if !shooted:
		shootingCooldown.start()
		shooted = true
		
func _process(delta):
	if GameManager.currentScene.bossInst.health <= 0 and !finishedOnce:
		$fleeing.interpolate_property(self, "position", self.position, Vector2(-30, self.position.y), 1)
		$fleeing.start()
		vulnerable = false
		shootingCooldown.stop()
		finishedOnce = true

func _on_ShootTimer_timeout():
	if vulnerable == true:
		$tripleShootingTimer.start()

func _on_tripleShootingTimer_timeout():
	if vulnerable == true:
		if timesShooted <= 2:
			shoot()
			bull.isRainbowy = true
			var dir = (get_parent().get_node("player").global_position - global_position).normalized()
			bull.global_rotation = dir.angle() + PI / 2.0
			bull.direction = dir
			timesShooted += 1
		else:
			$tripleShootingTimer.stop()
			timesShooted = 0

func _on_moving_tween_all_completed():
	vulnerable = true

func _on_fleeing_tween_all_completed():
	queue_free()
