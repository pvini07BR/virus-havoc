extends Area2D

func _ready():
	$CollisionShape2D/explosion2.play("explosion")
	
	z_index = 5
	z_as_relative = false

func _on_explosion2_animation_finished(anim_name):
	if anim_name == "explosion":
		queue_free()
