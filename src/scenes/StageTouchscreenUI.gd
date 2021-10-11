extends CanvasLayer

onready var joystickButton = $joystick/button

var opacity

func _init():
	var path = "user://settings.cfg"
	var file = File.new()
	if file.file_exists(path):
		var config = ConfigFile.new()
		var err = config.load(path)
		if err == OK:
			opacity = config.get_value("touchscreenUI", "opacity", 1)
			config.save(path)
	else:
		opacity = 1
		
		file.open(path,File.WRITE)
		file.close()
		
		var config = ConfigFile.new()
		var err = config.load(path)
		if err == OK:
			config.set_value("touchscreenUI", "opacity", 1)
			config.save(path)

func _ready():
	$CanvasModulate.color = Color(1,1,1,0)
	
	if GameManager.wasInBossBattle == true:
		$CanvasModulate.color = Color(1,1,1,opacity)
	
func _on_stage_started():
	var trans = Tween.new()
	trans.interpolate_property($CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,opacity), 0.5)
	add_child(trans)
	trans.start()
	yield(trans,"tween_all_completed")
	trans.queue_free()
	
func _on_stage_ended():
	var trans = Tween.new()
	trans.interpolate_property($CanvasModulate, "color", Color(1,1,1,opacity), Color(1,1,1,0), 0.5)
	add_child(trans)
	trans.start()
	yield(trans,"tween_all_completed")
	trans.queue_free()
