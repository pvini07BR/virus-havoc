extends Area2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 0
var moving = false
var shooted = false

func _ready():
	z_index = 1
	z_as_relative = false
	
	$fade.interpolate_property($laserBullet, "modulate", Color(1,1,1,0), Color(1,1,1,1),0.5,Tween.TRANS_LINEAR)
	$fade.start()
	
	$Tween.interpolate_property($laserBullet.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$Tween.start()
func _process(delta):
	translate(direction*speed*delta)
	if moving == true and !shooted:
		$speed.interpolate_property(self, "speed", 0, 750, 0.2, Tween.TRANS_LINEAR)
		$speed.start()
		self.add_to_group('projectile')
		shooted = true

func _on_VirusBullet_area_entered(area):
	if area.is_in_group("virus"):
		if moving == true:
			queue_free()
		
func _physics_process(_delta):
	if !moving:
		var dir = (get_viewport().get_mouse_position() - global_position).normalized()
		global_rotation = dir.angle() + PI / 2.0
		direction = dir
	
	if self.position.x <= 0:
		queue_free()
	if self.position.x >= 1280:
		queue_free()
	if self.position.y <= 0:
		queue_free()
	if self.position.y >= 720:
		queue_free()
