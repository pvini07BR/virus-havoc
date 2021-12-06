extends Virus

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
		var bull = projectile.instance()
		bull.damage = 1
		GameManager.currentScene.add_child(bull)
		bull.global_position = global_position
		bull.velocity.x = -1
		bull.velocity.y = -0.8
		bull.set_collision_layer_bit(2, 4)
		bull.set_collision_mask_bit(2, 4)
		
		var bull2 = projectile.instance()
		bull2.damage = 1
		GameManager.currentScene.add_child(bull2)
		bull2.global_position = global_position
		bull2.velocity.x = -1
		bull2.velocity.y = 0.8
		bull2.set_collision_layer_bit(3, 8)
		bull2.set_collision_mask_bit(3, 8)
