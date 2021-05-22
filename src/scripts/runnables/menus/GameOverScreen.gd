extends Node2D

func _ready():
	get_tree().get_root().get_node("GameManager/musicChannel").stop()
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
	if GameManager.language == 0:
		$UI/exit.text = "Sair"
		$UI/continue.text = "Continuar"
		
		$areYouSure/text.text = "Tem certeza?"
		
		$areYouSure/yes.text = "Sim"
		$areYouSure/no.text = "Não"
	if GameManager.language == 1:
		$UI/exit.text = "Exit"
		$UI/continue.text = "Continue"
		
		$areYouSure/text.text = "Are you sure?"
		
		$areYouSure/yes.text = "Yes"
		$areYouSure/no.text = "No"
	
func _on_Crash_finished():
	$Fade/Fadeing.play("FadeIn")

func _on_Fadeing_animation_finished(anim_name):
	if anim_name == "FadeIn":
		$Fade.offset.x = -1280
		$Fade.offset.y = -720

func _on_continue_pressed():
	$UI.queue_free()
	$areYouSure.queue_free()
	$BrokenShip_Anim.play("gameOver_recovering")
	$"Crash!".stream = load("res://assets/sounds/GameOver_recovering.wav")
	$"Crash!".volume_db = -10
	$"Crash!".play()

func _on_BrokenShip_Anim_animation_finished(anim_name):
	if anim_name == "gameOver_recovering":
		$BrokenShip_Anim.play("gameOver_recovered")
	if anim_name == "gameOver_recovered":
		GameManager.get_node("Fade").path = GameManager.stages.values()[GameManager.lastStagePlayed]
		GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_exit_pressed():
	$areYouSure.offset.x = 0
	$areYouSure.offset.y = 0

func _on_yes_pressed():
	GameManager.get_node("Fade").path = "res://scenes/stages/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_no_pressed():
	$areYouSure.offset.x = -1280
	$areYouSure.offset.y = -720

func _on_BrokenShip_Anim_animation_started(anim_name):
	if anim_name == "gameOver_recovered":
		$"Crash!".stream = load("res://assets/sounds/GameOver_recovered.wav")
		$"Crash!".volume_db = -10
		$"Crash!".play()
		
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_tree().paused = true
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			get_tree().paused = false
