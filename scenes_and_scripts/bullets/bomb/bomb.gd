extends Area2D

const explosion = preload("res://scenes_and_scripts/bullets/explosion/explosion.tscn")
var direction : Vector2 = Vector2.RIGHT
var speed = 0
var bombLaunched = false
var damage := 0

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
	$counter.start()
	
func _physics_process(_delta):
	if self.position.x > 1280:
		queue_free()
	
func _on_commonBomb_area_entered(area):
	if area.is_in_group("virus"):
		if bombLaunched == true:
			explode()
			
func explode():
	var boom = explosion.instance()
	boom.damage = damage
	boom.add_to_group("projectile")
	GameManager.currentScene.call_deferred("add_child", boom)
	boom.global_position = global_position
	queue_free()

func _on_counter_timeout():
	if bombLaunched == true:
		explode()
