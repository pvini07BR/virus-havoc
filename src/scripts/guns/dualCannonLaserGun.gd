extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		var bull = projectile.instance()
		get_tree().get_root().add_child(bull)
		bull.global_position = $pos.global_position
		
		var bull2 = projectile.instance()
		get_tree().get_root().add_child(bull2)
		bull2.global_position = $pos2.global_position
		$cooldown.start()
		cooldown = true

func _on_cooldown_timeout():
	cooldown = false
