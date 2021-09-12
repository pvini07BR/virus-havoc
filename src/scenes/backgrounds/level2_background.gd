extends Node2D

func _process(delta):
	$BG.texture = $Viewport.get_texture()
	
	$binaryEffectRender.texture = $binaryEffect.get_texture()
