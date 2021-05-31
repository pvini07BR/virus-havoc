extends "res://scripts/bases/virus.gd"

var timesShooted = 0
var finishedOnce = false

func _ready():
	z_index = 5
	z_as_relative = false
	
	rng.randomize()
	$tripleShootingTimer.wait_time = rng.randf_range(0.3, 0.5)
	var randomX = rng.randf_range(480, 960)
	var randomY = rng.randf_range(50, 666)
	
	$moving.interpolate_property(self, "position", Vector2(1310, randomY), Vector2(randomX, randomY), rng.randf_range(1,4))
	$moving.start()
	
	$rotating.interpolate_property($Sprite, "rotation_degrees", 0, 360, 1)
	$rotating.start()
	
	$rainbow.interpolate_property($Sprite.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbow.start()

func _physics_process(delta):
	#if get_parent().get_parent().virusSpaceMoving == 2:
		#match get_parent().get_parent().virusSpaceRotDirection:
			#0: rotation_degrees -= get_parent().get_parent().virusSpaceVelocity * delta
			#1: rotation_degrees += get_parent().get_parent().virusSpaceVelocity * delta
	#else:
		#rotation_degrees = 0
		
	if get_parent().stageFinished == true and !finishedOnce:
		$moving.interpolate_property(self, "position", self.position, Vector2(-30, self.position.y), 1)
		$moving.start()
		vulnerable = false
		shootingCooldown.stop()
		finishedOnce = true
	
	if !shooted:
		shootingCooldown.start()
		shooted = true
		
func _on_CommonVirus_area_entered(area: Area2D):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			takeDamage()

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
	if get_parent().stageFinished == true:
		queue_free()
