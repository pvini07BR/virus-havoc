extends Stage

func _on_stage_started():
	if !stageFinished:
		$paperPlaneSpawning.start()
		$shootingFolderSpawning.start()
		$trashBinSpawner.start()

func _on_paperPlaneSpawning_timeout():
	add_child(viruses[0].instance())

func _on_shootingFolderSpawning_timeout():
	add_child(viruses[1].instance())

func _on_trashBinSpawner_timeout():
	add_child(viruses[2].instance())
