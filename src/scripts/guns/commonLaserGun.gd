extends "res://scripts/bases/gun.gd"

func _input(Event):
	if get_parent().isInputWorking == true:
		if active == true:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					var bull = projectile.instance()
					get_tree().get_nodes_in_group("stage")[0].add_child(bull)
					bull.global_position = $pos.global_position
					cooldown = true
					shootingPlayer.play()
					$cooldown.start()
				
func _on_cooldown_timeout():
	cooldown = false
