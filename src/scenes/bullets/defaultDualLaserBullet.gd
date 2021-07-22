extends Node2D

var existingBullets = 2
var speed

func _init():
	speed = 500
	
func _ready():
	z_index = 1
	z_as_relative = false

func _on_1_area_entered(area):
	if area.is_in_group("virus"):
		get_node("1").queue_free()
		existingBullets -= 1
		
func _on_2_area_entered(area):
	if area.is_in_group("virus"):
		get_node("2").queue_free()
		existingBullets -= 1
		
func _process(delta):
	position += Vector2(speed * delta, 0)
	
	if existingBullets <= 0:
		queue_free()

func _physics_process(_delta):
	if self.position.x > 1280:
		queue_free()
