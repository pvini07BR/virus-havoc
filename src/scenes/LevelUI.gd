extends CanvasLayer

func _ready():
	$CanvasModulate.color = Color(1,1,1,0)
	$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,1), 0.5)
	
	if GameManager.wasInBossBattle == true:
		$CanvasModulate.color = Color(1,1,1,1)
		$bossHealth.visible = true
		
func _on_stage_started():
	if !GameManager.wasInBossBattle:
		$appearingTween.start()

func _process(delta):
	$topLeft/playerHealth.text = (TranslationServer.translate("STAGE_UI_HEALTH") + ": " + str(GameManager.currentScene.playerInst.hp))
	$topLeft/virusesKilled.text = (TranslationServer.translate("STAGE_UI_VIRUSES_KILLED") + ": " + str(GameManager.currentScene.virusesKilled))
	$topRight/score.text = (TranslationServer.translate("STAGE_UI_SCORE") + ": " + str(GameManager.currentScene.score))
	$topRight/bitcoins.text = (TranslationServer.translate("STAGE_UI_BITCOINS") + ": " + str(GameManager.currentScene.bitcoins))
	
	$bottomRight/HBoxContainer/gunPreview.texture = GameManager.currentScene.guns[GameManager.currentScene.gunIndex].previewSprite
	$bottomRight/gunEquipped.text = GameManager.currentScene.guns[GameManager.currentScene.gunIndex].gunName
	
	if GameManager.currentScene.isBossFight == true:
		$bossHealth.text = (TranslationServer.translate("STAGE_UI_BOSS_HEALTH") + ": " + str(GameManager.currentScene.bossInst.health))
		$bossHealth.visible = true
	else:
		$bossHealth.visible = false
	
	if GameManager.currentScene.gunIndex == 0:
		$guns/slot1/selector.visible = true
		$guns/slot2/selector.visible = false
	elif GameManager.currentScene.gunIndex == 1:
		$guns/slot1/selector.visible = false
		$guns/slot2/selector.visible = true
	else:
		$guns/slot1/selector.visible = false
		$guns/slot2/selector.visible = false
		
	if GameManager.currentScene.guns.size() == 1:
		if !GameManager.currentScene.guns[0] == null:
			$guns/slot1/sprite.texture = GameManager.currentScene.guns[0].previewSprite
	elif GameManager.currentScene.guns.size() >= 2:
		if !GameManager.currentScene.guns[0] == null:
			$guns/slot1/sprite.texture = GameManager.currentScene.guns[0].previewSprite
		if !GameManager.currentScene.guns[1] == null:
			$guns/slot2/sprite.texture = GameManager.currentScene.guns[1].previewSprite

func _on_stage_ended():
	$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,1), Color(1,1,1,0), 0.5)
	$appearingTween.start()

#func _process(_delta):
#	if GameManager.language == 0:
#		$playerHealth.text = ("Vida: %d" % get_parent().get_node("player").hp)
#		$virusesKilled.text = ("Matou: %d" % get_parent().virusesKilled)
#		$score.text = ("Pontos: %d" % get_parent().score)
#		$score/bitcoins.text = ("Bitcoins ganhos: %d" % get_parent().bitcoins)
#		$pauseMenu/pauseText.text = "PAUSADO"
#		$pauseMenu/resumeGameButton.text = "Reniciar Nível"
#		$pauseMenu/goBackButton.text = "Voltar para o menu"
#		$levelFinished/score.text = ("Pontuação: %d" % scoreTemp)
#		$levelFinished/bitcoins.text = ("Bitcoins Ganhos: %d" % bitcoinsTemp)
#
#		if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
#			$gunEquipped.text = get_parent().get_node("player").gunInstance.namePTBR
#		if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
#			$gunEquipped.text = get_parent().get_node("player").gun2Instance.namePTBR
#		$selectingGuntoSub/whichOne.text = "Qual Substituir?"
#		$discard.text = "Descartar"
#		$pauseMenu/resume.text = "Retomar Jogo"
#
#		$levelFinished/title.text = "NÍVEL COMPLETO!"
#		$levelFinished/goBack.text = "Voltar para o menu"
#		$levelFinished/restartStage.text = "Jogar Novamente"
#		$levelFinished/goToNextLevel.text = "Jogar o próximo nivel"
#	if GameManager.language == 1:
#		$playerHealth.text = ("Health: %d" % get_parent().get_node("player").hp)
#		$virusesKilled.text = ("Killed: %d" % get_parent().virusesKilled)
#		$score.text = ("Score: %d" % get_parent().score)
#		$score/bitcoins.text = ("Bitcoins Earned: %d" % get_parent().bitcoins)
#		$pauseMenu/pauseText.text = "PAUSED"
#		$pauseMenu/resumeGameButton.text = "Restart Stage"
#		$pauseMenu/goBackButton.text = "Go back to menu"
#		$pauseMenu/resume.text = "Resume Game"
#
#		$levelFinished/title.text = "STAGE CLEAR!"
#		$levelFinished/goBack.text = "Go back to menu"
#		$levelFinished/restartStage.text = "Play Again"
#		$levelFinished/goToNextLevel.text = "Play the next stage"
#
#		$levelFinished/score.text = ("Score: %d" % scoreTemp)
#		$levelFinished/bitcoins.text = ("Bitcoins Earned: %d" % bitcoinsTemp)
#
#		if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
#			$gunEquipped.text = get_parent().get_node("player").gunInstance.nameEng
#		if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
#			$gunEquipped.text = get_parent().get_node("player").gun2Instance.nameEng
#		$selectingGuntoSub/whichOne.text = "Which one to replace?"
#		$discard.text = "Discard"
#
#	if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
#		if !get_parent().get_node("player").gunInstance.previewSprite == null:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.previewSprite
#		else:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.gunNotFoundSprite
#
#		$selecting.rect_position.x = 471
#		$selecting.rect_position.y = 18
#	if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
#		if !get_parent().get_node("player").gun2Instance.previewSprite == null:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.previewSprite
#		else:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.gunNotFoundSprite
#		$selecting.rect_position.x = 614
#		$selecting.rect_position.y = 18
#
#	if get_parent().get_node("player").doesHaveAFirstGun == true:
#		if !get_parent().get_node("player").gunInstance.previewSprite == null:
#			$gunsEquippedSlot1.texture = get_parent().get_node("player").gunInstance.previewSprite
#		else:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.gunNotFoundSprite
#
#	if get_parent().get_node("player").doesHaveASecondGun == true:
#		if !get_parent().get_node("player").gun2Instance.previewSprite == null:
#			$gunsEquippedSlot2.texture = get_parent().get_node("player").gun2Instance.previewSprite
#		else:
#			$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.gunNotFoundSprite
#
#		$gunsEquippedSlot2.visible = true
#
#	if get_parent().isBossFight == true:
#		if !GameManager.currentScene.bossInst == null or !GameManager.currentScene.boss == null:
#			$bossHealth.visible = true
#			$bossHealth.text = ("Boss: %d" % GameManager.currentScene.bossInst.health)
#
#	if isSubAGun == true:
#		if !pauseOnce:
#			get_parent().get_node("pause").itsPaused += 1
#			pauseOnce = true
#		if gunSelected <= -1:
#			gunSelected = 0
#		if gunSelected == 0:
#			$selectingGuntoSub.rect_position.x = 345
#			$selectingGuntoSub.rect_position.y = 73
#
#			$selectingGuntoSub.visible = true
#			$selectingGuntoSub/whichOne.visible = false
#			$discard.visible = true
#		if gunSelected == 1:
#			$selectingGuntoSub.rect_position.x = 471
#			$selectingGuntoSub.rect_position.y = 18
#
#			$selectingGuntoSub.visible = true
#			$selectingGuntoSub/whichOne.visible = true
#			$discard.visible = true
#		if gunSelected == 2:
#			$selectingGuntoSub.rect_position.x = 614
#			$selectingGuntoSub.rect_position.y = 18
#
#			$selectingGuntoSub.visible = true
#			$selectingGuntoSub/whichOne.visible = true
#			$discard.visible = true
#		if gunSelected >= 3:
#			gunSelected = 2
#	else:
#		$selectingGuntoSub.visible = false
#		$selectingGuntoSub/whichOne.visible = false
#		$discard.visible = false
#
#	if get_parent().stageBegun == true and !isAppearing and !GameManager.wasInBossBattle:
#		$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,1), 0.5)
#		$appearingTween.start()
#		isAppearing = true
#	if get_parent().stageFinished == true and !isDesappearing:
#		$appearingTween.interpolate_property($CanvasModulate, "color", Color(1,1,1,1), Color(1,1,1,0), 0.5)
#		$appearingTween.start()
#		isDesappearing = true
#
#	if get_parent().get_node("pause").itsPaused == 1:
#		if !get_parent().get_node("LevelUI").isSubAGun:
#			$pauseMenu.offset = Vector2(0,0)
#			if !musicPlaying:
#				$pauseMenu/pauseMusic_FadeIn.interpolate_property($pauseMenu/pauseMusic, "volume_db", -80, 0, 4)
#				$pauseMenu/pauseMusic_FadeIn.start()
#				musicPlaying = true
#	else:
#		$pauseMenu.offset = Vector2(-1280, -720)
#		if musicPlaying == true:
#			$pauseMenu/pauseMusic_FadeIn.stop_all()
#			$pauseMenu/pauseMusic.stop()
#			$pauseMenu/pauseMusic.volume_db = -80
#			$pauseMenu/pauseMusic.stream = pauseMusic
#			easterEggCounter = 0
#			musicPlaying = false
#
#	if get_parent().get_node("player").hp <= 3:
#		$critic.play("healthCritic")
#	else:
#		$critic.stop()
#		$playerHealth.modulate = Color(255, 255, 255)
		
#func _input(Event):
#	if Event.is_action_pressed("ui_selectWeapon0") and isSubAGun == true:
#		gunSelected -= 1
#	if Event.is_action_pressed("ui_selectWeapon1") and isSubAGun == true:
#		gunSelected += 1
#	if Event.is_action_pressed("ui_accept") and isSubAGun == true:
#		if gunSelected == 0:
#			isSubAGun = false
#			if pauseOnce == true:
#				get_parent().get_node("pause").itsPaused += 1
#				pauseOnce = false
#		if gunSelected == 1:
#			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
#				get_parent().get_node("player").changeToExistingGun()
#				isSubAGun = false
#				if pauseOnce == true:
#					get_parent().get_node("pause").itsPaused += 1
#					get_parent().get_node("player").get_node("gunSwitching").play()
#					pauseOnce = false
#			else:
#				GameManager.equippedGuns[0] = get_parent().get_node("LootBox").decidedGun
#				get_parent().get_node("player").replace_gun()
#				isSubAGun = false
#				if pauseOnce == true:
#					get_parent().get_node("pause").itsPaused += 1
#					get_parent().get_node("player").get_node("gunSwitching").play()
#					pauseOnce = false
#		if gunSelected == 2:
#			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
#				get_parent().get_node("player").changeToExistingGun()
#				isSubAGun = false
#				if pauseOnce == true:
#					get_parent().get_node("pause").itsPaused += 1
#					get_parent().get_node("player").get_node("gunSwitching").play()
#					pauseOnce = false
#			else:
#				GameManager.equippedGuns[1] = get_parent().get_node("LootBox").decidedGun
#				get_parent().get_node("player").replace_gun()
#				isSubAGun = false
#				if pauseOnce == true:
#					get_parent().get_node("pause").itsPaused += 1
#					get_parent().get_node("player").get_node("gunSwitching").play()
#					pauseOnce = false

#func _on_goBackButton_pressed():
#	get_parent().get_node("pause").itsPaused = 2
#	get_parent().get_node("player").isInputWorking = false
#	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
#	GameManager.get_node("Fade/layer/anim").play("fadeOut")
#	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)

#func _on_resumeGameButton_pressed():
#	get_parent().get_node("pause").itsPaused = 2
#	GameManager.wasInBossBattle = false
#	GameManager.get_node("Fade").path = GameManager.stages[GameManager.lastStagePlayed]
#	GameManager.get_node("Fade/layer/anim").play("fadeOut")
#	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
#func makeLevelFinishedAppear():
#	$levelFinished.offset = Vector2(0,0)
#	$levelFinished/titleMoving.interpolate_property($levelFinished/title, "rect_position", $levelFinished/title.rect_position, Vector2(0, $levelFinished/title.rect_position.y), 1)
#	$levelFinished/titleMoving.start()

#func _on_resume_pressed():
#	get_parent().get_node("pause").itsPaused += 1

#func _on_pauseMusic_FadeIn_tween_started(object, key):
#	$pauseMenu/pauseMusic.play()
	
#func _notification(what):
#	match what:
#		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
#			$pauseMenu/pauseMusic.stream_paused = true
#			if $pauseMenu/pauseMusic_FadeIn.is_active():
#				$pauseMenu/pauseMusic_FadeIn.set_active(false)
#		MainLoop.NOTIFICATION_WM_FOCUS_IN:
#			if !$pauseMenu/pauseMusic_FadeIn.is_active():
#				$pauseMenu/pauseMusic_FadeIn.set_active(true)
#			$pauseMenu/pauseMusic.stream_paused = false

#func _on_pauseMusic_finished():
#	if musicPlaying == true:
#		if !easterEggCounter == 30:
#			$pauseMenu/pauseMusic.stream = pauseMusic
#			$pauseMenu/pauseMusic.play()
#			easterEggCounter += 1
#		else:
#			$pauseMenu/pauseMusic.stream = coolEasterEgg
#			$pauseMenu/pauseMusic.play()
#			easterEggCounter = 0

#func _on_goToNextLevel_pressed():
#	GameManager.storedBitcoins = 0
#	GameManager.storedKills = 0
#	GameManager.storedScore = 0
#	GameManager.wasInBossBattle = false
#	GameManager.lastStagePlayed = GameManager.lastStagePlayed + 1
#	GameManager.get_node("Fade").path = GameManager.stages[GameManager.lastStagePlayed]
#	GameManager.get_node("Fade/layer/anim").play("fadeOut")

#func _on_titleMoving_tween_all_completed():
#	isStageFinished = true
#	countUp()

#func countUp():
#	$levelFinished/score.visible = true
#	if !scoreTemp == get_parent().score:
#		var scoreCounter = Tween.new()
#		scoreCounter.interpolate_property(self, "scoreTemp", scoreTemp, get_parent().score, 1)
#		add_child(scoreCounter)
#		scoreCounter.start()
#		yield(scoreCounter, "tween_all_completed")
#	else:
#		scoreTemp = get_parent().score
#	$levelFinished/bitcoins.visible = true
#	if !bitcoinsTemp == get_parent().bitcoins:
#		var bitcoinCounter = Tween.new()
#		bitcoinCounter.interpolate_property(self, "bitcoinsTemp", bitcoinsTemp, get_parent().bitcoins, 1)
#		add_child(bitcoinCounter)
#		bitcoinCounter.start()
#		yield(bitcoinCounter,"tween_all_completed")
#	else:
#		bitcoinsTemp = get_parent().bitcoins
#	$levelFinished/goBack.visible = true
#	$levelFinished/restartStage.visible = true
#	$levelFinished/goToNextLevel.visible = true
#
#	$levelFinished/goBack.disabled = false
#	$levelFinished/restartStage.disabled = false
#	if GameManager.lastStagePlayed < GameManager.stages.size() - 1:
#		$levelFinished/goToNextLevel.disabled = false
#	elif GameManager.lastStagePlayed == GameManager.stages.size() - 1:
#		$levelFinished/goToNextLevel.disabled = true
