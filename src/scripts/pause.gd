extends Node

var itsPaused = 0

func _process(_delta):
	if itsPaused == 1:
		if get_parent().get_node("LevelUI").isSubAGun == true:
			get_tree().get_root().get_node("GameManager/musicChannel").pause_mode = Node.PAUSE_MODE_PROCESS
		else:
			get_tree().get_root().get_node("GameManager/musicChannel").pause_mode = Node.PAUSE_MODE_STOP
		get_tree().paused = true
	if itsPaused >= 2:
		get_tree().paused = false
		itsPaused = 0
		
	if get_parent().get_node("player").hp <= 0:
		GameManager.goto_scene("res://scenes/runnables/menus/GameOverScreen.tscn")

func _input(Event):
	if Event.is_action_pressed("ui_cancel"):
		if !get_parent().get_node("LevelUI").isSubAGun and !get_parent().stageFinished and get_parent().stageBegun == true:
			itsPaused += 1

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			if !itsPaused == 1:
				get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			if !itsPaused == 1:
				get_tree().paused = false
