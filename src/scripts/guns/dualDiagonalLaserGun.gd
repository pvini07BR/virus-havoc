extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		var bull = projectile.instance()
		get_tree().get_root().add_child(bull)
		bull.global_position = global_position
		bull.velocity.x = 1
		bull.velocity.y = -0.8
		
		var bull2 = projectile.instance()
		get_tree().get_root().add_child(bull2)
		bull2.global_position = global_position
		bull2.velocity.x = 1
		bull2.velocity.y = 0.8
		$cooldown.start()
		cooldown = true

func _on_cooldown_timeout():
	cooldown = false
