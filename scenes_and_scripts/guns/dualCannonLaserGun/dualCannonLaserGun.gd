extends Gun

func _input(Event):
	if GameManager.currentScene.inputWorking == true:
		if active == true:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					var bull = projectile.instance()
					bull.damage = damage
					bull.direction = Vector2(1.0, 0.0)
					GameManager.currentScene.add_child(bull)
					bull.global_position = $pos.global_position
					
					var bull2 = projectile.instance()
					bull2.damage = damage
					bull2.direction = Vector2(1.0, 0.0)
					GameManager.currentScene.add_child(bull2)
					bull2.global_position = $pos2.global_position
					
					if !shootingSound == null:
						SoundManager.playSound(shootingSound, -10, 1)
					$cooldown.start()
					cooldown = true
					yield($cooldown,"timeout")
					cooldown = false
