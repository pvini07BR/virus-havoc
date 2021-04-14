extends Node2D

var itsPaused = 0

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false

func _process(_delta):
	if itsPaused == 1:
		get_tree().paused = true
	if itsPaused >= 2:
		get_tree().paused = false
		itsPaused = 0
		
	if get_parent().get_node("player").hp <= 0:
		get_tree().paused = true


func _input(Event):
	if Event.is_action_pressed("ui_cancel"):
		itsPaused += 1
