extends AudioStreamPlayer

func _on_damageSoundHandler_finished():
	queue_free()
