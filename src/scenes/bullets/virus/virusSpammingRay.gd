extends Area2D

func _on_expanding_animation_finished(anim_name):
	queue_free()
