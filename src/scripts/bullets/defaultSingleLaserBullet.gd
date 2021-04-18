extends Area2D

var speed

func _init():
	speed = 500
	
func _ready():
	z_index = 1
	z_as_relative = false

func _on_Tiro_area_entered(area: Area2D):
	if area.is_in_group("virus"):
		queue_free()
		
func _process(delta):
	position += Vector2(speed * delta, 0)

func _physics_process(_delta):
	if self.position.x > 1280:
		queue_free()
		
#queria fazer a bala mudar de cor aff
#func change_color(color):
	#$col/laserBullet.get_canvas_item()
