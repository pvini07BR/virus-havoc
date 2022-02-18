extends Bullet

var speed : float = 500
var direction : Vector2
	
func _ready():
	z_index = 1
	z_as_relative = false

func _process(delta):
	translate(direction*speed*delta)
	global_rotation = direction.angle() + PI * 2.0
	if self.position.x > 1280:
		queue_free()

func _on_laser_area_entered(area):
	if isEnemy:
		if area.is_in_group("player"):
			queue_free()
	else:
		if area.is_in_group("virus"):
			queue_free()
