extends Node2D

func _ready():
	get_tree().get_root().get_node("GameManager/musicChannel").stop()
	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
	
	if GameManager.language == 0:
		$UI/exit.text = "Sair"
		$UI/continue.text = "Continuar"
		
		$UI/areYouSure/text.text = "Tem certeza?"
		
		$UI/areYouSure/yes.text = "Sim"
		$UI/areYouSure/no.text = "Não"
	if GameManager.language == 1:
		$UI/exit.text = "Exit"
		$UI/continue.text = "Continue"
		
		$UI/areYouSure/text.text = "Are you sure?"
		
		$UI/areYouSure/yes.text = "Yes"
		$UI/areYouSure/no.text = "No"
	
func _on_Crash_finished():
	$Fade/Fadeing.play("FadeIn")

func _on_Fadeing_animation_finished(anim_name):
	if anim_name == "FadeIn":
		$Fade.offset.x = -1280
		$Fade.offset.y = -720

func _on_continue_pressed():
	$UI.offset.x = -1280
	$UI.offset.y = -720
	$BrokenShip_Anim.play("gameOver_recovering")
	$"Crash!".stream = load("res://assets/sounds/GameOver_recovering.wav")
	$"Crash!".play()

func _on_BrokenShip_Anim_animation_finished(anim_name):
	if anim_name == "gameOver_recovering":
		$BrokenShip_Anim.play("gameOver_recovered")
	if anim_name == "gameOver_recovered":
		GameManager.get_node("Fade").path = "res://scenes/stages/levels/Level1.tscn"
		GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_exit_pressed():
	$UI/areYouSure.offset.x = 0
	$UI/areYouSure.offset.y = 0

func _on_yes_pressed():
	GameManager.get_node("Fade").path = "res://scenes/stages/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_no_pressed():
	$UI/areYouSure.offset.x = -1280
	$UI/areYouSure.offset.y = -720

func _on_BrokenShip_Anim_animation_started(anim_name):
	if anim_name == "gameOver_recovered":
		$"Crash!".stream = load("res://assets/sounds/GameOver_recovered.wav")
		$"Crash!".play()
