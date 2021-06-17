extends CanvasLayer

var isSubAGun = false
var gunSelected = 1
var easterEggCounter = 0
var pauseMusic = preload("res://assets/music/pause.ogg")
var coolEasterEgg = preload("res://assets/music/pause_secret.ogg")
var pauseOnce = false
var musicPlaying = false

var isStageFinished = false
var levelFinishedMenuState = 0

var scoreTemp = 0
var bitcoinsTemp = 0

var isAppearing = false
var isDesappearing = false

func _ready():
	$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,1), 0.5)
	
	if GameManager.wasInBossBattle == true:
		$CanvasModulate.color = Color(1,1,1,1)

func _process(_delta):
	if GameManager.language == 0:
		$playerHealth.text = ("Vida: %d" % get_parent().get_node("player").hp)
		$virusesKilled.text = ("Matou: %d" % get_parent().virusesKilled)
		$score.text = ("Pontos: %d" % get_parent().score)
		$score/bitcoins.text = ("Bitcoins ganhos: %d" % get_parent().bitcoins)
		$pauseMenu/pauseText.text = "PAUSADO"
		$pauseMenu/resumeGameButton.text = "Reniciar Nível"
		$pauseMenu/goBackButton.text = "Voltar para o menu"
		
		if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
			$gunEquipped.text = get_parent().get_node("player").gunInstance.namePTBR
		if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
			$gunEquipped.text = get_parent().get_node("player").gun2Instance.namePTBR
		$selectingGuntoSub/whichOne.text = "Qual Substituir?"
		$discard.text = "Descartar"
		$pauseMenu/resume.text = "Retomar Jogo"
		
		$levelFinished/title.text = "NÍVEL COMPLETO!"
		$levelFinished/goBack.text = "Voltar para o menu"
		$levelFinished/restartStage.text = "Jogar Novamente"
		$levelFinished/goToNextLevel.text = "Jogar o próximo nivel"
	if GameManager.language == 1:
		$playerHealth.text = ("Health: %d" % get_parent().get_node("player").hp)
		$virusesKilled.text = ("Killed: %d" % get_parent().virusesKilled)
		$score.text = ("Score: %d" % get_parent().score)
		$score/bitcoins.text = ("Bitcoins Earned: %d" % get_parent().bitcoins)
		$pauseMenu/pauseText.text = "PAUSED"
		$pauseMenu/resumeGameButton.text = "Restart Stage"
		$pauseMenu/goBackButton.text = "Go back to menu"
		$pauseMenu/resume.text = "Resume Game"
		
		$levelFinished/title.text = "STAGE CLEAR!"
		$levelFinished/goBack.text = "Go back to menu"
		$levelFinished/restartStage.text = "Play Again"
		$levelFinished/goToNextLevel.text = "Play the next stage"
		
		if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
			$gunEquipped.text = get_parent().get_node("player").gunInstance.nameEng
		if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
			$gunEquipped.text = get_parent().get_node("player").gun2Instance.nameEng
		$selectingGuntoSub/whichOne.text = "Which one to replace?"
		$discard.text = "Discard"
			
	if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
		if !get_parent().get_node("player").gunInstance.previewSprite == null:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.previewSprite
		else:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.gunNotFoundSprite
				
		$selecting.rect_position.x = 471
		$selecting.rect_position.y = 18
	if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
		if !get_parent().get_node("player").gun2Instance.previewSprite == null:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.previewSprite
		else:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.gunNotFoundSprite
		$selecting.rect_position.x = 614
		$selecting.rect_position.y = 18
		
	if get_parent().get_node("player").doesHaveAFirstGun == true:
		if !get_parent().get_node("player").gunInstance.previewSprite == null:
			$gunsEquippedSlot1.texture = get_parent().get_node("player").gunInstance.previewSprite
		else:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.gunNotFoundSprite
		
	if get_parent().get_node("player").doesHaveASecondGun == true:
		if !get_parent().get_node("player").gun2Instance.previewSprite == null:
			$gunsEquippedSlot2.texture = get_parent().get_node("player").gun2Instance.previewSprite
		else:
			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.gunNotFoundSprite
		
		$gunsEquippedSlot2.visible = true
	
	if get_parent().isBossFight == true:
		if !GameManager.currentScene.bossInst == null or !GameManager.currentScene.boss == null:
			$bossHealth.visible = true
			$bossHealth.text = ("Boss: %d" % GameManager.currentScene.bossInst.health)
		
	if isSubAGun == true:
		if !pauseOnce:
			get_parent().get_node("pause").itsPaused += 1
			pauseOnce = true
		if gunSelected <= -1:
			gunSelected = 0
		if gunSelected == 0:
			$selectingGuntoSub.rect_position.x = 345
			$selectingGuntoSub.rect_position.y = 73
			
			$selectingGuntoSub.visible = true
			$selectingGuntoSub/whichOne.visible = false
			$discard.visible = true
		if gunSelected == 1:
			$selectingGuntoSub.rect_position.x = 471
			$selectingGuntoSub.rect_position.y = 18
			
			$selectingGuntoSub.visible = true
			$selectingGuntoSub/whichOne.visible = true
			$discard.visible = true
		if gunSelected == 2:
			$selectingGuntoSub.rect_position.x = 614
			$selectingGuntoSub.rect_position.y = 18
			
			$selectingGuntoSub.visible = true
			$selectingGuntoSub/whichOne.visible = true
			$discard.visible = true
		if gunSelected >= 3:
			gunSelected = 2
	else:
		$selectingGuntoSub.visible = false
		$selectingGuntoSub/whichOne.visible = false
		$discard.visible = false
		
	if get_parent().stageBegun == true and !isAppearing and !GameManager.wasInBossBattle:
		$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,1), 0.5)
		$appearingTween.start()
		isAppearing = true
	if get_parent().stageFinished == true and !isDesappearing:
		$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,1), Color(1,1,1,0), 0.5)
		$appearingTween.start()
		isDesappearing = true
		
	if get_parent().get_node("pause").itsPaused == 1:
		if !get_parent().get_node("LevelUI").isSubAGun:
			$pauseMenu.offset = Vector2(0,0)
			if !musicPlaying:
				$pauseMenu/pauseMusic_FadeIn.interpolate_property($pauseMenu/pauseMusic, "volume_db", -80, 0, 4)
				$pauseMenu/pauseMusic_FadeIn.start()
				musicPlaying = true
	else:
		$pauseMenu.offset = Vector2(-1280, -720)
		if musicPlaying == true:
			$pauseMenu/pauseMusic_FadeIn.stop_all()
			$pauseMenu/pauseMusic.stop()
			$pauseMenu/pauseMusic.volume_db = -80
			easterEggCounter = 0
			musicPlaying = false
		
	if get_parent().get_node("player").hp <= 3:
		$critic.play("healthCritic")
	else:
		$critic.stop()
		$playerHealth.modulate = Color(255, 255, 255)
		
func _input(Event):
	if Event.is_action_pressed("ui_cancel"):
		if isStageFinished == true:
			levelFinishedMenuState = 2
			$levelFinished/score.visible = true
			if GameManager.language == 0:
				$levelFinished/score.text = ("Pontuação: %d" % get_parent().score)
			if GameManager.language == 1:
				$levelFinished/score.text = ("Score: %d" % get_parent().score)
				
			$levelFinished/bitcoins.visible = true
			if GameManager.language == 0:
				$levelFinished/bitcoins.text = ("Bitcoins Ganhos: %d" % get_parent().bitcoins)
			if GameManager.language == 1:
				$levelFinished/bitcoins.text = ("Bitcoins Earned: %d" % get_parent().bitcoins)
			isStageFinished = false
	
	if Event.is_action_pressed("ui_selectWeapon0") and isSubAGun == true:
		gunSelected -= 1
	if Event.is_action_pressed("ui_selectWeapon1") and isSubAGun == true:
		gunSelected += 1
	if Event.is_action_pressed("ui_accept") and isSubAGun == true:
		if gunSelected == 0:
			isSubAGun = false
			if pauseOnce == true:
				get_parent().get_node("pause").itsPaused += 1
				pauseOnce = false
		if gunSelected == 1:
			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
				get_parent().get_node("player").changeToExistingGun()
				isSubAGun = false
				if pauseOnce == true:
					get_parent().get_node("pause").itsPaused += 1
					get_parent().get_node("player").get_node("gunSwitching").play()
					pauseOnce = false
			else:
				GameManager.equippedGuns[0] = get_parent().get_node("LootBox").decidedGun
				get_parent().get_node("player").replace_gun()
				isSubAGun = false
				if pauseOnce == true:
					get_parent().get_node("pause").itsPaused += 1
					get_parent().get_node("player").get_node("gunSwitching").play()
					pauseOnce = false
		if gunSelected == 2:
			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
				get_parent().get_node("player").changeToExistingGun()
				isSubAGun = false
				if pauseOnce == true:
					get_parent().get_node("pause").itsPaused += 1
					get_parent().get_node("player").get_node("gunSwitching").play()
					pauseOnce = false
			else:
				GameManager.equippedGuns[1] = get_parent().get_node("LootBox").decidedGun
				get_parent().get_node("player").replace_gun()
				isSubAGun = false
				if pauseOnce == true:
					get_parent().get_node("pause").itsPaused += 1
					get_parent().get_node("player").get_node("gunSwitching").play()
					pauseOnce = false

func _on_goBackButton_pressed():
	get_parent().get_node("pause").itsPaused = 2
	get_parent().get_node("player").isInputWorking = false
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)

func _on_resumeGameButton_pressed():
	get_parent().get_node("pause").itsPaused = 2
	GameManager.wasInBossBattle = false
	GameManager.get_node("Fade").path = GameManager.stages.values()[GameManager.lastStagePlayed]
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
func makeLevelFinishedAppear():
	$levelFinished.offset = Vector2(0,0)
	$levelFinished/titleMoving.interpolate_property($levelFinished/title, "rect_position", $levelFinished/title.rect_position, Vector2(0, $levelFinished/title.rect_position.y), 1)
	$levelFinished/titleMoving.start()

func _on_resume_pressed():
	get_parent().get_node("pause").itsPaused += 1

func _on_pauseMusic_FadeIn_tween_started(object, key):
	$pauseMenu/pauseMusic.play()
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			$pauseMenu/pauseMusic.stream_paused = true
			if $pauseMenu/pauseMusic_FadeIn.is_active():
				$pauseMenu/pauseMusic_FadeIn.set_active(false)
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			if !$pauseMenu/pauseMusic_FadeIn.is_active():
				$pauseMenu/pauseMusic_FadeIn.set_active(true)
			$pauseMenu/pauseMusic.stream_paused = false

func _on_pauseMusic_finished():
	if musicPlaying == true:
		if !easterEggCounter == 30:
			$pauseMenu/pauseMusic.stream = pauseMusic
			$pauseMenu/pauseMusic.play()
			easterEggCounter += 1
		else:
			$pauseMenu/pauseMusic.stream = coolEasterEgg
			$pauseMenu/pauseMusic.play()
			easterEggCounter = 0

func _on_goToNextLevel_pressed():
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	GameManager.get_node("Fade").path = GameManager.stages.values()[GameManager.lastStagePlayed + 1]
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_titleMoving_tween_all_completed():
	$levelFinished/Timer.start()
	$levelFinished/score.visible = true
	isStageFinished = true

func _on_Timer_timeout():
	if levelFinishedMenuState == 0:
		if !get_parent().score == 0:
			if get_parent().score > 0:
				$levelFinished/Timer.wait_time = float(0.001) / float(get_parent().score)
			elif get_parent().score < 0:
				$levelFinished/Timer.wait_time = float(0.001) / float(+get_parent().score)
		if scoreTemp < get_parent().score:
			scoreTemp += 1
			if GameManager.language == 0:
				$levelFinished/score.text = ("Pontuação: %d" % scoreTemp)
			if GameManager.language == 1:
				$levelFinished/score.text = ("Score: %d" % scoreTemp)
		if scoreTemp > get_parent().score:
			scoreTemp -= 1
			if GameManager.language == 0:
				$levelFinished/score.text = ("Pontuação: %d" % scoreTemp)
			if GameManager.language == 1:
				$levelFinished/score.text = ("Score: %d" % scoreTemp)
		if scoreTemp == get_parent().score:
			if GameManager.language == 0:
				$levelFinished/score.text = ("Pontuação: %d" % get_parent().score)
			if GameManager.language == 1:
				$levelFinished/score.text = ("Score: %d" % get_parent().score)
			levelFinishedMenuState = 1
		$levelFinished/Timer.start()
	if levelFinishedMenuState == 1:
		if !get_parent().bitcoins == 0:
			if get_parent().bitcoins > 0:
				$levelFinished/Timer.wait_time = float(0.001) / float(get_parent().bitcoins)
			elif get_parent().bitcoins < 0:
				$levelFinished/Timer.wait_time = float(0.001) / float(+get_parent().bitcoins)
		$levelFinished/bitcoins.visible = true
		if bitcoinsTemp < get_parent().bitcoins:
			bitcoinsTemp += 1
			if GameManager.language == 0:
				$levelFinished/bitcoins.text = ("Bitcoins Ganhos: %d" % bitcoinsTemp)
			if GameManager.language == 1:
				$levelFinished/bitcoins.text = ("Bitcoins Earned: %d" % bitcoinsTemp)
		if bitcoinsTemp > get_parent().bitcoins:
			bitcoinsTemp -= 1
			if GameManager.language == 0:
				$levelFinished/bitcoins.text = ("Bitcoins Ganhos: %d" % bitcoinsTemp)
			if GameManager.language == 1:
				$levelFinished/bitcoins.text = ("Bitcoins Earned: %d" % bitcoinsTemp)
		if bitcoinsTemp == get_parent().bitcoins:
			if GameManager.language == 0:
				$levelFinished/bitcoins.text = ("Bitcoins Ganhos: %d" % get_parent().bitcoins)
			if GameManager.language == 1:
				$levelFinished/bitcoins.text = ("Bitcoins Earned: %d" % get_parent().bitcoins)
			levelFinishedMenuState = 2
		$levelFinished/Timer.start()
	if levelFinishedMenuState == 2:
		$levelFinished/goBack.visible = true
		$levelFinished/restartStage.visible = true
		$levelFinished/goToNextLevel.visible = true
		
		$levelFinished/goBack.disabled = false
		$levelFinished/restartStage.disabled = false
		if GameManager.lastStagePlayed < GameManager.stages.values().size() - 1:
			$levelFinished/goToNextLevel.disabled = false
		elif GameManager.lastStagePlayed == GameManager.stages.values().size() - 1:
			$levelFinished/goToNextLevel.disabled = true
