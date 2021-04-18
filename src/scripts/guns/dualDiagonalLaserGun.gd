extends "res://scripts/guns/gun.gd"

func fire():
	if !cooldown:
		randomize()
		damage = [1, 1.5, 2][randi() % 3]
		var bull = projectile.instance()
		get_tree().get_nodes_in_group("level")[0].add_child(bull)
		bull.global_position = $pos2.global_position
		bull.velocity.x = 1
		bull.velocity.y = -0.8
		
		var bull2 = projectile.instance()
		get_tree().get_nodes_in_group("level")[0].add_child(bull2)
		bull2.global_position = $pos.global_position
		bull2.velocity.x = 1
		bull2.velocity.y = 0.8
		$cooldown.start()
		cooldown = true

func _on_cooldown_timeout():
	cooldown = false
