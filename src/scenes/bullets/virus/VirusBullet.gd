extends VirusBullet

var direction : Vector2 = Vector2.LEFT
var speed : float = 500
var isRainbowy = false
var rainbowActivated = false

func _process(delta):
	translate(direction*speed*delta)
	
	if isRainbowy == true and !rainbowActivated:
		$rainbowEf.play("rainbow")
		rainbowActivated = true
	else:
		$rainbowEf.stop(true)
		modulate = Color(1, 0.5, 0.5)
		

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
