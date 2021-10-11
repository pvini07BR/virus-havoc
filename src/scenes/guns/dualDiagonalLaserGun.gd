extends Gun

func _input(Event):
	if GameManager.currentScene.inputWorking == true:
		if active == true:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					randomize()
					damage = [1, 1.5, 2][randi() % 3]
					var bull = projectile.instance()
					bull.damage = damage
					GameManager.currentScene.add_child(bull)
					bull.global_position = $pos2.global_position
					bull.velocity.x = 1
					bull.velocity.y = -0.8
					bull.set_collision_layer_bit(1, 2)
					bull.set_collision_mask_bit(1, 2)
					
					var bull2 = projectile.instance()
					bull2.damage = damage
					GameManager.currentScene.add_child(bull2)
					bull2.global_position = $pos.global_position
					bull2.velocity.x = 1
					bull2.velocity.y = 0.8
					bull2.set_collision_layer_bit(2, 4)
					bull2.set_collision_mask_bit(2, 4)
					
					if !shootingSound == null:
						SoundManager.playSound(shootingSound, -10, 1)
					
					$cooldown.start()
					cooldown = true

func _on_cooldown_timeout():
	cooldown = false
