extends "res://scripts/bases/virus.gd"

func _physics_process(delta):
	if get_parent().get_parent().virusSpaceMoving == 2:
		match get_parent().get_parent().virusSpaceRotDirection:
			0: rotation_degrees -= get_parent().get_parent().virusSpaceVelocity * delta
			1: rotation_degrees += get_parent().get_parent().virusSpaceVelocity * delta
	else:
		rotation_degrees = 0
	
	if !shooted:
		shootingCooldown.start()
		shooted = true

	if get_parent().get_parent().virusSpaceMoving == 2:
		vulnerable = true

func _on_ShootTimer_timeout():
	if vulnerable == true:
		shoot()
		var dir = (get_parent().get_parent().get_node("player").global_position - global_position).normalized()
		bull.global_rotation = dir.angle() + PI / 2.0
		bull.direction = dir
