extends Area2D

const explosion = preload("res://scenes/bullets/explosion.tscn")
var explosionCounter = 0
var direction : Vector2 = Vector2.RIGHT
var speed = 0
var bombLaunched = false

func _ready():
	get_parent().bombExists = true
	set_as_toplevel(false)
	
	z_index = 1
	z_as_relative = false
	
func _process(_delta):
	translate(direction*speed*_delta)

func launch():
	speed = 500
	get_parent().bombExists = false
	bombLaunched = true
	set_as_toplevel(true)
	position = get_parent().get_node("bombPos").global_position
	$col/bombAnim.play("bombRotate")
	
func _physics_process(_delta):
	if self.position.x > 1280:
		queue_free()
	if get_parent().bombExists == false:
		explosionCounter += 1
	if explosionCounter >= 45:
		if bombLaunched == true:
			explode()
	
func _on_commonBomb_area_entered(area):
	if area.is_in_group("virus"):
		if bombLaunched == true:
			explode()
			
func explode():
	var boom = explosion.instance()
	get_tree().get_root().call_deferred("add_child", boom)
	boom.global_position = global_position
	queue_free()
