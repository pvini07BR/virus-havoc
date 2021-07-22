extends "res://scripts/bases/virusBullet.gd"

var explosion = preload("res://scenes/bullets/explosion.tscn")
var released = false

func _init():
	z_index = 3

func launch():
	set_as_toplevel(true)
	global_position = get_parent().get_node("bombPos").global_position
	$positioning.interpolate_property(self, "global_position", Vector2(global_position.x, global_position.y), Vector2(get_parent().get_parent().get_node("player").global_position.x, global_position.y), 0.1)
	$positioning.start()
	released = true

func _on_falling_tween_all_completed():
	queue_free()

func _on_virusZipBomb_area_entered(area):
	if area.is_in_group("player"):
		get_parent().hasLaunched = true
		var expl = explosion.instance()
		expl.add_to_group("explosion")
		expl.global_position = global_position
		get_tree().get_nodes_in_group("stage")[0].add_child(expl)
		
		queue_free()

func _on_positioning_tween_all_completed():
	$falling.interpolate_property(self, "global_position", global_position, Vector2(global_position.x, 1300), 2)
	$falling.start()
