extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_player = get_node("AnimationPlayer")
onready var panel = get_node("panel")
var isItOpen : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if anim_player.current_animation == "opening" and panel.frame in [3]:
		if (!isItOpen):
			print("ae")
			isItOpen = true
		pass
