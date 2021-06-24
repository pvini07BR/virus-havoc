extends "res://scripts/bases/stage.gd"

var virusSpaceVelocity = 0
var virusSpaceRotDirection = 0
var virusSpaceDir : Vector2 = Vector2.LEFT
var virusSpaceWave = 1
var virusWaveJustSpawned = false

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
var isCanvasAppearing = false
	
func _on_stage_started():
	$virusSpawningTimer.start()
	
func _ready():
	if GameManager.wasInBossBattle == true:
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	
func _process(delta):
	if stageBegun == true and !isCanvasAppearing and !GameManager.wasInBossBattle:
		$CanvasLayer/Tween.interpolate_property($CanvasLayer/CanvasModulate, "color", Color(1,1,1,0), Color(1,1,1,1), 0.5)
		$CanvasLayer/Tween.start()
		isCanvasAppearing = true

	if !stageFinished:
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
					if virusSpaceWave >= 11:
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
							spawnLootBox()
							spawnWave(
								[viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1]], 
								200, 200, "clockwise", 50
								)
						5:
							spawnWave(
								[viruses[1], 
								viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1]],
								200, 200, "clockwise", 70)
						6:
							spawnWave(
								[viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1],
								viruses[0],
								viruses[1]], 
								200, 200, "clockwise", 50
								)
						7:
							spawnLootBox()
							$brokenVirusSpawningTimer.start()
							spawnWave(
								[viruses[1],
								viruses[0],
								viruses[1],
								viruses[2],
								viruses[1],
								viruses[0]],
								200, 200, "clockwise", 55
								)
						8:
							spawnWave(
								[viruses[0],
								viruses[1],
								viruses[2],
								viruses[2],
								viruses[2],
								viruses[1],
								viruses[0]],
								200, 200, "clockwise", 60
								)
						9:
							spawnWave(
								[viruses[0],
								viruses[2],
								viruses[1],
								viruses[2],
								viruses[1],
								viruses[2],
								viruses[1],
								viruses[0]],
								200, 200, "clockwise", 65
								)
						10:
							spawnWave(
								[viruses[0],
								viruses[1],
								viruses[2],
								viruses[1],
								viruses[0],
								viruses[1],
								viruses[2],
								viruses[1],
								viruses[0]],
								100, 200, "clockwise", 50
								)
					virusWaveJustSpawned = true
					
				if !$virusSpace.position.x < 1000:
					$virusSpace.translate(virusSpaceVelocity * 4.5 *virusSpaceDir*delta)
				else:
					virusSpaceMoving = 2
		else:
			$CanvasLayer/Label.visible = false
	elif stageFinished == true:
		$CanvasLayer/Label.visible = false
				
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
	if isBossFight == true and !bossInst.health <= 0:
		add_child(viruses[4].instance())
		$rainbowServantSpawningTimer.start()
