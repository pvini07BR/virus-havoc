extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		var bull = projectile.instance()
		get_tree().get_nodes_in_group("level")[0].add_child(bull)
		bull.global_position = $pos.global_position
		#bull.change_color(0.65)
		
		var bull2 = projectile.instance()
		get_tree().get_nodes_in_group("level")[0].add_child(bull2)
		bull2.global_position = $pos2.global_position
		get_parent().get_node("gunShoot").play()
		$cooldown.start()
		#bull.change_color(0.65)
		cooldown = true

func _on_cooldown_timeout():
	cooldown = false
