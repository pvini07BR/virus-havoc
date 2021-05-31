extends Area2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 500
var isRainbowy = false
var rainbowActivated = false

func _ready():
	z_index = 1
	z_as_relative = false

func _process(delta):
	translate(direction*speed*delta)
	
	if isRainbowy == true and !rainbowActivated:
		$rainbowEffect.interpolate_property($laserBullet.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
		$rainbowEffect.start()
		rainbowActivated = true

func _on_VirusBullet_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
		
func _physics_process(_delta):
	if self.position.x <= 0:
		queue_free()
	if self.position.x >= 1280:
		queue_free()
	if self.position.y <= 0:
		queue_free()
	if self.position.y >= 720:
		queue_free()
