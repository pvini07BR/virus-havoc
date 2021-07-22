extends Node2D

func _ready():
	if GameManager.language == 0:
		$bg/text.text = "Carregando..."
	if GameManager.language == 1:
		$bg/text.text = "Now loading..."
		
	$bg/rotatingvirus.interpolate_property($bg/virus, "rotation_degrees", 0, 360, 1)
	$bg/rotatingvirus.start()
