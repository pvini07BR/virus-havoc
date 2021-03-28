extends Area2D

const TIRO = preload("res://scenes/Tiro_padrão.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _on_Tiro_area_entered(area):
	if area.is_in_group("tiro"):
		print("colidiu")
