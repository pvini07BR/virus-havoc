extends CanvasLayer

var isSubAGun = false
var gunSelected = 1

func _process(_delta):
	if GameManager.language == 0:
		$playerHealth.text = ("Vida: %d" % get_parent().get_node("player").hp)
		$playerHealth/virusesKilled.text = ("Matou: %d" % get_parent().virusesKilled)
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
	if GameManager.language == 1:
		$playerHealth.text = ("Health: %d" % get_parent().get_node("player").hp)
		$playerHealth/virusesKilled.text = ("Killed: %d" % get_parent().virusesKilled)
		$score.text = ("Score: %d" % get_parent().score)
		$score/bitcoins.text = ("Bitcoins Earned: %d" % get_parent().bitcoins)
		$pauseMenu/pauseText.text = "PAUSED"
		$pauseMenu/resumeGameButton.text = "Restart Stage"
		$pauseMenu/goBackButton.text = "Go back to menu"
		
		if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
			$gunEquipped.text = get_parent().get_node("player").gunInstance.nameEng
		if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
			$gunEquipped.text = get_parent().get_node("player").gun2Instance.nameEng
		$selectingGuntoSub/whichOne.text = "Which one to replace?"
		$discard.text = "Discard"
			
	if get_parent().get_node("player").slotSelected == 0 and get_parent().get_node("player").doesHaveAFirstGun == true:
		$gunEquipped/gunPreview.texture = get_parent().get_node("player").gunInstance.previewSprite
		$gunEquipped/gunPreview.offset.x = -get_parent().get_node("player").gunInstance.previewSprite.get_width()
		$gunEquipped/gunPreview.offset.y = -get_parent().get_node("player").gunInstance.previewSprite.get_height()
				
		$selecting.rect_position.x = 471
		$selecting.rect_position.y = 18
	if get_parent().get_node("player").slotSelected == 1 and get_parent().get_node("player").doesHaveASecondGun == true:
		$gunEquipped/gunPreview.texture = get_parent().get_node("player").gun2Instance.previewSprite
		$gunEquipped/gunPreview.offset.x = -get_parent().get_node("player").gun2Instance.previewSprite.get_width()
		$gunEquipped/gunPreview.offset.y = -get_parent().get_node("player").gunInstance.previewSprite.get_height()
		$selecting.rect_position.x = 614
		$selecting.rect_position.y = 18
		
	if get_parent().get_node("player").doesHaveAFirstGun == true:
		$gunsEquippedSlot1.texture = get_parent().get_node("player").gunInstance.previewSprite
		
		$gunsEquippedSlot1BG.rect_size.x = get_parent().get_node("player").gunInstance.previewSprite.get_width()
		$gunsEquippedSlot1BG.rect_size.y = get_parent().get_node("player").gunInstance.previewSprite.get_height()
	if get_parent().get_node("player").doesHaveASecondGun == true:
		$gunsEquippedSlot2.texture = get_parent().get_node("player").gun2Instance.previewSprite
		
		$gunsEquippedSlot2BG.rect_size.x = get_parent().get_node("player").gun2Instance.previewSprite.get_width()
		$gunsEquippedSlot2BG.rect_size.y = get_parent().get_node("player").gun2Instance.previewSprite.get_height()
		$gunsEquippedSlot2.visible = true
	
	if get_parent().isBossFight == true:
		$bossHealth.visible = true
		$bossHealth.text = ("Boss: %d" % get_parent().get_node("rainbowVirus").health)
		
	if isSubAGun == true:
		get_tree().paused = true
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
		
	if get_parent().get_node("pause").itsPaused == 1:
		$pauseMenu.offset.x = 0
		$pauseMenu.offset.y = 0
	else:
		$pauseMenu.offset.x = -1280
		$pauseMenu.offset.y = -720
		
func _input(Event):
	if Event.is_action_pressed("ui_selectWeapon0") and isSubAGun == true:
		gunSelected -= 1
	if Event.is_action_pressed("ui_selectWeapon1") and isSubAGun == true:
		gunSelected += 1
	if Event.is_action_pressed("ui_accept") and isSubAGun == true:
		if gunSelected == 0:
			isSubAGun = false
			get_tree().paused = false
		if gunSelected == 1:
			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
				get_parent().get_node("player").changeToExistingGun()
				isSubAGun = false
				get_tree().paused = false
			else:
				GameManager.equippedGuns[0] = get_parent().get_node("LootBox").decidedGun
				get_parent().get_node("player").replace_gun()
				isSubAGun = false
				get_tree().paused = false
		if gunSelected == 2:
			if GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun or GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
				get_parent().get_node("player").changeToExistingGun()
				isSubAGun = false
				get_tree().paused = false
			else:
				GameManager.equippedGuns[1] = get_parent().get_node("LootBox").decidedGun
				get_parent().get_node("player").replace_gun()
				isSubAGun = false
				get_tree().paused = false

func _on_goBackButton_pressed():
	get_parent().get_node("pause").itsPaused = 2
	GameManager.get_node("Fade").path = "res://scenes/stages/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_resumeGameButton_pressed():
	get_parent().get_node("pause").itsPaused = 2
	GameManager.wasInBossBattle = false
	GameManager.get_node("Fade").path = "res://scenes/stages/levels/Level1.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
