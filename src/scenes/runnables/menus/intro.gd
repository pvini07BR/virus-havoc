extends Node

func _ready():
	if GameManager.language == 0:
		$Label.text = "Apresenta"
	elif GameManager.language == 1:
		$Label.text = "Presents"
		
func _on_AnimationPlayer_animation_finished(anim_name):
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	
func _unhandled_key_input(event):
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
