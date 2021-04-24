extends Node

var itsPaused = 0
var pauseOnce = false
onready var deathSound = load("res://assets/sounds/shipCrashing_GameOver.wav")

func _process(_delta):
	if itsPaused == 1:
		get_tree().paused = true
		if get_parent().get_node("player").hp <= 0 and !pauseOnce:
			get_parent().get_node("player").get_node("Hits").stream = deathSound
			get_parent().get_node("player").get_node("Hits").volume_db = 0
			get_parent().get_node("player").get_node("Hits").play()
			pauseOnce = true
	if itsPaused >= 2:
		get_tree().paused = false
		itsPaused = 0
		
	if get_parent().get_node("player").hp <= 0:
		GameManager.goto_scene("res://scenes/stages/menus/GameOverScreen.tscn")
		itsPaused = 1
		if GameManager.language == 0:
			get_parent().get_node("CanvasLayer/pauseMenu/pauseText").text = "VOCÊ PERDEU!"
			get_parent().get_node("CanvasLayer/pauseMenu/resumeGameButton").text = "Tentar Novamente"
		if GameManager.language == 1:
			get_parent().get_node("CanvasLayer/pauseMenu/pauseText").text = "GAME OVER"
			get_parent().get_node("CanvasLayer/pauseMenu/resumeGameButton").text = "Try Again"

func _input(Event):
	if Event.is_action_pressed("ui_cancel"):
		itsPaused += 1
