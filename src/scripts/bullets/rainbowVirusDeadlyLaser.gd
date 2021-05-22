extends Area2D

func _ready():
	z_index = 3
	z_as_relative = false
	
	$rainbowEffect.interpolate_property($ColorRect.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.start()
