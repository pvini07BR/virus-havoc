extends Area2D

func _ready():
	z_index = 5
	z_as_relative = false
	
	$appearTween.interpolate_property($ColorRect, "rect_scale", Vector2(1, 0), Vector2(1,1), 1)
	$appearTween.start()
	
func _physics_process(delta):
	var dir = (get_parent().get_node("player").global_position - global_position).normalized()
	global_rotation = lerp(dir.angle() + PI / 2.0, dir.angle() + PI / 2.0, 100 * delta)
