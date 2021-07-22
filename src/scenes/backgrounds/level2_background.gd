extends Node2D

func _process(delta):
	var texture = $Viewport.get_texture()
	$BG.texture = texture
