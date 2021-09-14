extends Virus

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
	
	$rotating.interpolate_property($Sprite, "rotation_degrees", 0, 360, 1)
	$rotating.start()
	
	$rainbow.interpolate_property($Sprite.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbow.start()
		
func _process(delta):
	if get_parent().get_parent().virusSpaceMoving == 2:
		match get_parent().get_parent().virusSpaceRotDirection:
			0: rotation_degrees -= get_parent().get_parent().virusSpaceVelocity * delta
			1: rotation_degrees += get_parent().get_parent().virusSpaceVelocity * delta
	else:
		rotation_degrees = 0
	
	if get_parent().get_parent().virusSpaceMoving == 2:
		vulnerable = true
	
	if !shooted:
		shootingCooldown.start()
		shooted = true
	
	if GameManager.currentScene.bossInst.health <= 0 and !finishedOnce:
		$fleeing.interpolate_property(self, "global_position", self.global_position, Vector2(-30, self.global_position.y), 1)
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
			var bull = projectile.instance()
			bull.damage = 1
			GameManager.currentScene.add_child(bull)
			bull.global_position = global_position
			bull.isRainbowy = true
			var dir = (get_tree().get_nodes_in_group("stage")[0].get_node("player").global_position - global_position).normalized()
			bull.global_rotation = dir.angle() + PI / 2.0
			bull.direction = dir
			timesShooted += 1
		else:
			$tripleShootingTimer.stop()
			timesShooted = 0

func _on_fleeing_tween_all_completed():
	queue_free()
