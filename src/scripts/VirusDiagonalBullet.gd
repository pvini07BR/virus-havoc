extends KinematicBody2D

var speed = 400
var velocity = Vector2.ZERO
var howManyTimesBounced = 0

func _ready():
	randomize()
	velocity.x = 0
	velocity.y = 0
	#colocar -1 e -0.8 para ir pra cima esquerda
	#colocar -1 e 0.8 para ir baixo esquerda
	
	z_index = 1
	z_as_relative = false
	
func _physics_process(delta):
	var collision_object = move_and_collide(velocity * speed * delta)
	if collision_object:
		velocity = velocity.bounce(collision_object.normal)
		howManyTimesBounced += 1
	if howManyTimesBounced >= 5:
		queue_free()
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
