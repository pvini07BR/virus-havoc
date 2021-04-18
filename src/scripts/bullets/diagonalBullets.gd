extends KinematicBody2D

var speed = 400
var velocity = Vector2.ZERO
var howManyTimesBounced = 0

func _ready():
	velocity.x = 0
	velocity.y = 0
	#colocar 1 e -0.8 para ir pra cima direita
	#colocar 1 e 0.8 para ir baixo direita
	
	z_index = 1
	z_as_relative = false
	
func _physics_process(delta):
	var collision_object = move_and_collide(velocity * speed * delta)
	if collision_object:
		velocity = velocity.bounce(collision_object.normal)
		howManyTimesBounced += 1
	if howManyTimesBounced >= 5:
		queue_free()
		
func _on_Area2D_area_entered(area):
	if area.is_in_group("virus"):
		queue_free()
