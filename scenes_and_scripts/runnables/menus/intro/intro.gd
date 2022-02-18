extends Node
		
func _on_AnimationPlayer_animation_finished(anim_name):
	go()
	
func _input(event):
	if event.is_pressed():
		go()
		
func go():
	GameManager.goto_scene(GameManager.menus["debug_menu"])
