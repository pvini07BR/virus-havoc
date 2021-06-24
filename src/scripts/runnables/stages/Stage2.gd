extends "res://scripts/bases/stage.gd"

func _on_stage_started():
	$paperPlaneSpawning.start()
	$shootingFolderSpawning.start()

func _on_paperPlaneSpawning_timeout():
	add_child(viruses[0].instance())

func _on_shootingFolderSpawning_timeout():
	add_child(viruses[1].instance())
