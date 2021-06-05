extends "res://scripts/bases/gun.gd"

func _input(Event):
	if active == true:
		if !get_parent().get_parent().stageFinished:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					var bull = projectile.instance()
					add_child(bull)
					bull.set_as_toplevel(true)
					bull.global_position = $pos.global_position
					shootingPlayer.play()
					$cooldown.start()
					cooldown = true

func _on_cooldown_timeout():
	cooldown = false
