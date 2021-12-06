extends Node
		
func _on_AnimationPlayer_animation_finished(anim_name):
	go()
	
func _input(event):
	if event.is_pressed():
		go()
		
func go():
	GameManager.get_node("Fade").path = "res://scenes_and_scripts/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
