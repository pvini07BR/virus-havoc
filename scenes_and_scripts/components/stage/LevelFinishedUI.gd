extends CanvasLayer

var scoreTemp := 0
var bitcoinsTemp := 0

func _ready():
	var scoreCounter = Tween.new()
	var bitcoinsCounter = Tween.new()
	
	$titleMoving.interpolate_property($title, "rect_position", Vector2(-1280, $title.rect_position.y), Vector2(0, $title.rect_position.y), 1)
	$titleMoving.start()
	yield($titleMoving,"tween_all_completed")
	
	$VBoxContainer/score.visible = true
	scoreCounter.interpolate_property(self, "scoreTemp", scoreTemp, GameManager.currentScene.score, 1)
	add_child(scoreCounter)
	scoreCounter.start()
		
	yield(scoreCounter, "tween_all_completed")
	scoreCounter.queue_free()
	
	$VBoxContainer/bitcoins.visible = true
	bitcoinsCounter.interpolate_property(self, "bitcoinsTemp", bitcoinsTemp, GameManager.currentScene.bitcoins, 1)
	add_child(bitcoinsCounter)
	bitcoinsCounter.start()
	
	yield(bitcoinsCounter,"tween_all_completed")
	bitcoinsCounter.queue_free()
	
	$VBoxContainer/goBack.visible = true
	$VBoxContainer/restartStage.visible = true
	$VBoxContainer/goToNextLevel.visible = true
	
	$VBoxContainer/goBack.disabled = false
	$VBoxContainer/restartStage.disabled = false
	$VBoxContainer/goToNextLevel.disabled = false
	
func _process(delta):
	$VBoxContainer/score.text = (TranslationServer.translate("STAGE_UI_SCORE") + ": " + str(scoreTemp))
	$VBoxContainer/bitcoins.text = (TranslationServer.translate("STAGE_UI_BITCOINS") + ": " + str(bitcoinsTemp))

func _on_goToNextLevel_pressed():
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	GameManager.lastStagePlayed = GameManager.lastStagePlayed + 1
	GameManager.goto_scene(GameManager.stages[GameManager.lastStagePlayed])

func _on_restartStage_pressed():
	GameManager.storedBitcoins = 0
	GameManager.storedKills = 0
	GameManager.storedScore = 0
	GameManager.wasInBossBattle = false
	GameManager.goto_scene(GameManager.stages[GameManager.lastStagePlayed])
	
func _on_goBack_pressed():
	GameManager.currentScene.inputWorking = false
	GameManager.goto_scene(GameManager.menus["debug_menu"])
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
