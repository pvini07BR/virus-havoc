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
