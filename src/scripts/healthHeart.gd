extends Area2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 500

func _process(delta):
	translate(direction*speed*delta)
	if position.x <= 0:
		queue_free()

func _on_healthHeart_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
