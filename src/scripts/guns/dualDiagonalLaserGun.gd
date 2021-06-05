extends "res://scripts/bases/gun.gd"

func _input(Event):
	if active == true:
		if !get_parent().get_parent().stageFinished:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					randomize()
					damage = [1, 1.5, 2][randi() % 3]
					var bull = projectile.instance()
					get_tree().get_nodes_in_group("stage")[0].add_child(bull)
					bull.global_position = $pos2.global_position
					bull.velocity.x = 1
					bull.velocity.y = -0.8
					bull.set_collision_layer_bit(1, 2)
					bull.set_collision_mask_bit(1, 2)
					
					var bull2 = projectile.instance()
					get_tree().get_nodes_in_group("stage")[0].add_child(bull2)
					bull2.global_position = $pos.global_position
					bull2.velocity.x = 1
					bull2.velocity.y = 0.8
					bull2.set_collision_layer_bit(2, 4)
					bull2.set_collision_mask_bit(2, 4)
					
					shootingPlayer.play()
					
					$cooldown.start()
					cooldown = true

func _on_cooldown_timeout():
	cooldown = false
