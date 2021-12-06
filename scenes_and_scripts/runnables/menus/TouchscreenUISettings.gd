extends Control

var music = preload("res://assets/music/menu.ogg")

func _ready():
	get_tree().paused = false
	if !get_tree().get_root().get_node("GameManager/musicChannel").stream == music:
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
		get_tree().get_root().get_node("GameManager/musicChannel").play()
	
	$StageTouchscreenUI/CanvasModulate.color = Color(1,1,1,$StageTouchscreenUI.opacity)
	$CanvasLayer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/OpacitySlider.value = $StageTouchscreenUI.opacity
	$CanvasLayer/VBoxContainer/HBoxContainer2/VBoxContainer/OpacityText.text = (TranslationServer.translate("SETTINGS_TOUCHSCREEN_UI_OPACITY") + ": " + str($StageTouchscreenUI.opacity))

func _on_OpacitySlider_value_changed(value):
	$StageTouchscreenUI/CanvasModulate.color = Color(1,1,1,value)
	$CanvasLayer/VBoxContainer/HBoxContainer2/VBoxContainer/OpacityText.text = (TranslationServer.translate("SETTINGS_TOUCHSCREEN_UI_OPACITY") + ": " + str(value))
	var path = "user://settings.cfg"
	var file = File.new()
	if file.file_exists(path):
		var config = ConfigFile.new()
		var err = config.load(path)
		if err == OK:
			config.set_value("touchscreenUI", "opacity", value)
			config.save(path)
	else:
		file.open(path,File.WRITE)
		file.close()
		
		var config = ConfigFile.new()
		var err = config.load(path)
		if err == OK:
			config.set_value("touchscreenUI", "opacity", value)
			config.save(path)

func _on_Button_pressed():
	GameManager.get_node("Fade").path = "res://scenes_and_scripts/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")
