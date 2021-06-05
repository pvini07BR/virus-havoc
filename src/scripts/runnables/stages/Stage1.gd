extends "res://scripts/bases/stage.gd"

var virusSpaceVelocity = 0
var virusSpaceRotDirection = 0
var virusSpaceDir : Vector2 = Vector2.LEFT
var virusSpaceWave = 1
var virusWaveJustSpawned = false
var bossBattleJustBegun = false

var virusSpaceMoving = 0
#número 0 para intervalo entre seções
#número 1 para quando a seção aparecer
#número 2 para quando a seção estiver pronta pra ação

var distance_from_center : float = 200
var distanceFrom : float
var distanceTo : float
var children : Array
var angle : float
var isDistanceTween : bool
var once = false
	
func _process(delta):
	children = $virusSpace.get_children()
	if !$virusSpace.get_child_count() <= 0:
		angle = TAU / $virusSpace.get_child_count()
		if !$virusSpace.get_child_count() <= 1:
			for i in $virusSpace.get_child_count():
				$changingPosTween.interpolate_property($virusSpace.get_children()[i], "position", $virusSpace.get_children()[i].position, Vector2.UP.rotated(i * angle) * distance_from_center, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$changingPosTween.start()
	
	if !isBossFight:
		if GameManager.language == 0:
			$CanvasLayer/Label.text = ("%da Onda" % virusSpaceWave)
		if GameManager.language == 1:
			$CanvasLayer/Label.text = ("Wave %d" % virusSpaceWave)
		
		if virusSpaceMoving == 0:
			$virusSpace.position.x = 1980
			$virusSpace.rotation_degrees = 0
			once = false
		
		if virusSpaceMoving == 2:
			if !once:
				$distancingTween.interpolate_property(self, "distance_from_center", distanceFrom, distanceTo, virusSpaceVelocity * 4.5 * delta, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$distancingTween.interpolate_property(self, "distance_from_center", distanceTo, distanceFrom, virusSpaceVelocity * 4.5 * delta, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, virusSpaceVelocity * 4.5 * delta)
				$distancingTween.start()
				once = true
			
			if virusSpaceRotDirection == 0:
				$virusSpace.rotation_degrees += virusSpaceVelocity * delta
			if virusSpaceRotDirection == 1:
				$virusSpace.rotation_degrees -= virusSpaceVelocity * delta
			if $virusSpace.get_child_count() == 0:
				virusSpaceMoving = 0
				virusSpaceWave += 1
				virusWaveJustSpawned = false
				$virusSpawningTimer.start()
				if virusSpaceWave >= 16:
					startBossFight()
			
		if virusSpaceMoving == 1:
			if !virusWaveJustSpawned:
				match virusSpaceWave:
					1: 
						spawnWave(
							[viruses[0], 
							viruses[0]], 
							200, 200, "clockwise", 50
							)
					2: 
						spawnWave([
							viruses[0], 
							viruses[0], 
							viruses[0]], 
							200, 200, "clockwise", 55
							)
					3:
						spawnWave(
							[viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0]], 
							200, 200, "clockwise", 60
							)
					4:
						spawnWave(
							[viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0]], 
							200, 200, "clockwise", 65
							)
					5:
						spawnWave(
							[viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0], 
							viruses[0]], 
							200, 200, "clockwise", 70
							)
					6:
						spawnLootBox()
						spawnWave(
							[viruses[0], 
							viruses[1], 
							viruses[0], 
							viruses[1]], 
							200, 200, "clockwise", 50
							)
					7:
						spawnWave(
							[viruses[1],
							viruses[0],
							viruses[1],
							viruses[0],
							viruses[1],
							viruses[0]],
							200, 200, "clockwise", 55
							)
					8:
						spawnWave(
							[viruses[1],
							viruses[1],
							viruses[0],
							viruses[1],
							viruses[1],
							viruses[0]],
							200, 200, "clockwise", 60
							)
					9:
						spawnWave(
							[viruses[1],
							viruses[1],
							viruses[1],
							viruses[0],
							viruses[1],
							viruses[1],
							viruses[1],
							viruses[0]],
							200, 200, "clockwise", 65
							)
					10:
						spawnLootBox()
						$brokenVirusSpawningTimer.start()
						spawnWave(
							[viruses[0],
							viruses[2],
							viruses[1],
							viruses[2],
							viruses[1]],
							100, 200, "clockwise", 50
							)
					11:
						spawnWave(
							[viruses[0],
							viruses[1],
							viruses[2],
							viruses[0],
							viruses[1],
							viruses[2]],
							100, 210, "clockwise", 55
							)
					12:
						spawnWave(
							[viruses[0],
							viruses[1],
							viruses[2],
							viruses[2],
							viruses[2],
							viruses[1],
							viruses[0]],
							100, 220, "clockwise", 60
							)
					13:
						spawnWave(
							[viruses[0],
							viruses[1],
							viruses[1],
							viruses[2],
							viruses[2],
							viruses[2],
							viruses[1],
							viruses[1]],
							100, 230, "clockwise", 65
							)
					14:
						spawnWave(
							[viruses[1],
							viruses[1],
							viruses[2],
							viruses[2],
							viruses[0],
							viruses[2],
							viruses[2],
							viruses[1],
							viruses[1]],
							100, 240, "clockwise", 70
							)
					15:
						spawnWave(
							[viruses[0],
							viruses[1],
							viruses[2],
							viruses[0],
							viruses[1],
							viruses[2],
							viruses[0],
							viruses[1],
							viruses[2]],
							100, 250, "clockwise", 75
							)
				virusWaveJustSpawned = true
				
			if !$virusSpace.position.x < 1000:
				$virusSpace.translate(virusSpaceVelocity * 4.5 *virusSpaceDir*delta)
			else:
				virusSpaceMoving = 2
	else:
		$CanvasLayer/Label.text = "Boss Fight!"
		if !bossBattleJustBegun:
			$rainbowServantSpawningTimer.start()
			bossBattleJustBegun = true
		if stageFinished == true:
			if GameManager.language == 0:
				$CanvasLayer/Label.text = "Nível Completo!"
			if GameManager.language == 1:
				$CanvasLayer/Label.text = "Stage Clear!"
func _on_virusSpawningTimer_timeout():
	if !isBossFight:
		if virusSpaceMoving == 0:
			virusSpaceMoving = 1
		
func spawnWave(type_and_amount : Array, distanceF, distanceT, direction, speed):
	distanceFrom = distanceF
	distanceTo = distanceT
	
	if direction == "clockwise":
		virusSpaceRotDirection = 0
	if direction == "anti-clockwise":
		virusSpaceRotDirection = 1
	virusSpaceVelocity = speed
	
	for i in type_and_amount.size():
		$virusSpace.add_child(type_and_amount[i].instance())
		
func _on_brokenVirusSpawningTimer_timeout():
	if !isBossFight:
		if virusSpaceMoving == 2:
			add_child(viruses[3].instance())
			
func _on_rainbowServantSpawningTimer_timeout():
	if isBossFight == true and !stageFinished:
		add_child(viruses[4].instance())
		$rainbowServantSpawningTimer.start()
#var lootBox = preload("res://scenes/LootBox.tscn")
#var lootBoxSpawningChance
#var lootBoxSpawnOnce = false
#var obtainedLootBoxBefore = false
#
#var wave0 = false
#var wave1 = false
#var wave2 = false
#var wave3 = false
#
#var virusesKilled = 0
#var score = 0
#var bitcoins = 0
#var isBossFight = false
#var isBossFightTriggerOnce = false
#var music = preload("res://assets/music/level1_music.ogg")
#var bossMusic = preload("res://assets/music/unused/boss1Music_notRemixed.ogg")
#
#func _ready():
#	if GameManager.wasInBossBattle == true:
#		isBossFight = true
#
#	get_tree().paused = false
#
#	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
#	get_tree().get_root().get_node("GameManager/musicChannel").set_stream(music)
#	get_tree().get_root().get_node("GameManager/musicChannel").play()
#	if !isBossFight:
#		if !wave0:
#			$virusSpawningTimer.start()
#			wave0 = true
#
#func _process(_delta):
#	if !isBossFight:
#		if virusesKilled == 20 and !wave1:
#			calculate_LootBoxProbab()
#			if lootBoxSpawningChance >= 2:
#				add_child(lootBox.instance())
#			$virusSpawningTimer2.start()
#			wave1 = true
#		if virusesKilled == 40 and !wave2:
#			$virusSpawningTimer3.start()
#			wave2 = true
#
#		if virusesKilled == 50 and !wave3:
#			if !obtainedLootBoxBefore:
#				calculate_LootBoxProbab()
#				if lootBoxSpawningChance >= 2:
#					add_child(lootBox.instance())
#			$virusSpawningTimer4.start()
#			wave3 = true
#	if virusesKilled >= 60 and !isBossFight:
#		isBossFight = true
#
#	bitcoins = score / 6
#	if bitcoins <= 0:
#		bitcoins = 0
#
#	if isBossFight == true:
#		if !isBossFightTriggerOnce:
#			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
#			get_tree().get_root().get_node("GameManager/musicChannel").set_stream(bossMusic)
#			get_tree().get_root().get_node("GameManager/musicChannel").play()
#			add_child(viruses.rainbowVirus_Boss.instance())
#			GameManager.wasInBossBattle = true
#			isBossFightTriggerOnce = true
#
#func _on_virusSpawningTimer_timeout():
#	if !isBossFight:
#		add_child(viruses[0].instance())
#
#func _on_virusSpawningTimer2_timeout():
#	if !isBossFight:
#		add_child(viruses[1].instance())
#
#func _on_virusSpawningTimer3_timeout():
#	if !isBossFight:
#		add_child(viruses.brokenVirus.instance())
#
#func _on_virusSpawningTimer4_timeout():
#	if !isBossFight:
#		add_child(viruses.dualDiagonalVirus.instance())
