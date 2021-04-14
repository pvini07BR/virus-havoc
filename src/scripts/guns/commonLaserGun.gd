extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		var bull = projectile.instance()
		get_tree().get_root().add_child(bull)
		bull.global_position = $pos.global_position
		cooldown = true
		$cooldown.start()

func _on_cooldown_timeout():
	cooldown = false
