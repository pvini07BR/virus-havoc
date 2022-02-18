extends CanvasLayer

var easterEggCounter = 0
var pauseMusic = preload("res://assets/music/pause.ogg")
var coolEasterEgg = preload("res://assets/music/pause_secret.ogg")
var canResume = false

func _ready():
	GameManager.itsAlreadyPaused = true
	get_tree().paused = true
	$pauseMusic_FadeIn.interpolate_property($pauseMusic, "volume_db", -80, 0, 4)
	$pauseMusic_FadeIn.start()

func _on_pauseMusic_finished():
	if !easterEggCounter == 30:
		$pauseMusic.stream = pauseMusic
		$pauseMusic.play()
		easterEggCounter += 1
	else:
		$pauseMusic.stream = coolEasterEgg
		$pauseMusic.play()
		easterEggCounter = 0

func _on_resume_pressed():
	if canResume == true:
		GameManager.itsAlreadyPaused = false
		get_tree().paused = false
		queue_free()
	
func _on_restartStage_pressed():
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	GameManager.lastStagePlayed = GameManager.lastStagePlayed
	GameManager.goto_scene(GameManager.stages[GameManager.lastStagePlayed])

func _on_goBackButton_pressed():
	GameManager.currentScene.inputWorking = false
	GameManager.goto_scene(GameManager.menus["debug_menu"])
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)

func _on_Timer_timeout():
	canResume = true

func _on_resume_button_up():
	$Timer.start()
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			$pauseMusic.stream_paused = true
			$pauseMusic_FadeIn.pause_mode = Node.PAUSE_MODE_STOP
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			$pauseMusic.stream_paused = false
			$pauseMusic_FadeIn.pause_mode = Node.PAUSE_MODE_INHERIT
