extends Node
		
func _on_AnimationPlayer_animation_finished(anim_name):
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	
func _input(event):
	if event.is_pressed():
		GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
		GameManager.get_node("Fade/layer/anim").play("fadeOut")
