extends "res://scripts/bases/virus.gd"

func _init():
	randomize()
	maxHealth = [3,4,5][randi() % 3]
	
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
		shoot2()
		bull.velocity.x = -1
		bull.velocity.y = -0.8
		bull.set_collision_layer_bit(2, 4)
		bull.set_collision_mask_bit(2, 4)
		
		bull2.velocity.x = -1
		bull2.velocity.y = 0.8
		bull2.set_collision_layer_bit(3, 8)
		bull2.set_collision_mask_bit(3, 8)
