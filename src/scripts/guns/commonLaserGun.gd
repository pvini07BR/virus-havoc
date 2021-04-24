extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		var bull = projectile.instance()
		get_tree().get_nodes_in_group("level")[0].add_child(bull)
		bull.global_position = $pos.global_position
		cooldown = true
		get_parent().get_node("gunShoot").play()
		$cooldown.start()
func _on_cooldown_timeout():
	cooldown = false
