extends Control

onready var anim_player = get_node("AnimationPlayer")
onready var panel = get_node("panel")
var isItOpen : bool = false

func _process(delta):
	if anim_player.current_animation == "opening" and panel.frame in [3]:
		if (!isItOpen):
			isItOpen = true
