extends Area2D

func _ready():
	$CollisionShape2D/explosion2.play("explosion")
	
	z_index = 10
	z_as_relative = false

func _on_explosion2_animation_finished(anim_name):
	if anim_name == "explosion":
		position.x = -666
		position.y = -666

func _on_BOOM_finished():
	queue_free()
