extends Node

export var equippedGuns = []
var language = 0

func _init():
	var gunsDir := Directory.new()
	var error = gunsDir.change_dir("res://scenes/guns/")
	if (error != OK):
		if language == 0:
			printerr("Falha ao carregar a pasta de armas.")
		elif language == 1:
			printerr("Failed to open guns folder.")
		return

	var guns := {}
	gunsDir.list_dir_begin(true, true)
	var next_file := gunsDir.get_next()
	while (next_file):
		if (next_file.get_extension() == "tscn"):
			guns[next_file] = load("res://scenes/guns/".plus_file(next_file))
		
		next_file = gunsDir.get_next()
		
	equippedGuns = [guns["commonLaserGun.tscn"]]

