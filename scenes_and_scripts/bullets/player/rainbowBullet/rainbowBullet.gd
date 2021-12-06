extends Bullet

var direction : Vector2 = Vector2.LEFT
var speed : float = 0
var moving = false
var shooted = false

func _ready():
	z_index = 1
	z_as_relative = false
	
	$fade.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1),0.5,Tween.TRANS_LINEAR)
	$fade.start()
	
	$Tween.interpolate_property($laserBullet, "self_modulate", Color(0,1,1,1), Color(1,1,1,1), 2, Tween.TRANS_LINEAR)
	$Tween.start()
func _process(delta):
	translate(direction*speed*delta)
	if moving == true and !shooted:
		$speed.interpolate_property(self, "speed", 0, 750, 0.2, Tween.TRANS_LINEAR)
		$speed.start()
		self.add_to_group('multiProjectile')
		shooted = true
		
	if !moving:
		var dir = (get_viewport().get_mouse_position() - global_position).normalized()
		global_rotation = dir.angle() + PI / 2.0
		direction = dir
		
		if position.x <= 0:
			position.x = 15
		if position.x >= 1280:
			position.x = 1265
		
	if moving == true:
		if position.x <= 0:
			queue_free()
		if position.x >= 1280:
			queue_free()
		if position.y <= 0:
			queue_free()
		if position.y >= 720:
			queue_free()

func _on_VirusBullet_area_entered(area):
	if area.is_in_group("virus"):
		if moving == true:
			queue_free()

