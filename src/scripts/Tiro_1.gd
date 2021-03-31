extends Tiro

func _init():
	speed = 500

func _physics_process(_delta):
	if self.position.x > 1280:
		queue_free()

func _on_Tiro_area_entered(area: Area2D):
	if area.is_in_group("virus"):
		queue_free()
