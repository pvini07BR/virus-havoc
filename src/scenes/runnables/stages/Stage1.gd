extends "res://scripts/bases/stage.gd"

var virusSpaceVelocity = 0
var virusSpaceRotDirection = 0
var virusSpaceWave = 1
var virusWaveJustSpawned = false
var virusSpaceMoving = 0
#número 0 para intervalo entre seções
#número 1 para quando a seção aparecer
#número 2 para quando a seção estiver pronta pra ação

var distance_from_center : float = 200
var distanceFromTo : Array = [null, null]
var children : Array
var angle : float
var isDistanceTween : bool
var distancingState : int
var isCanvasAppearing = false
var distancingOnce = false
	
func _on_stage_started():
	if !stageFinished:
		$virusSpawningTimer.start()
	
func _ready():
	if GameManager.wasInBossBattle == true:
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
		virusSpaceWave = 11
		distance_from_center = 280
		$virusSpawningTimer.wait_time = 20
	
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
					$virusSpace.get_children()[i].position = lerp($virusSpace.get_children()[i].position, Vector2.UP.rotated(i * angle) * distance_from_center, 0.05 * float(virusSpaceVelocity) * delta)
		
		if virusSpaceMoving == 0:
			$virusSpace.position.x = 1980
			$virusSpace.rotation_degrees = 0
		
		if !isBossFight:
			if GameManager.language == 0:
				$CanvasLayer/Label.text = ("%da Onda" % virusSpaceWave)
			if GameManager.language == 1:
				$CanvasLayer/Label.text = ("Wave %d" % virusSpaceWave)
		else:
			$CanvasLayer/Label.visible = false
			
		if virusSpaceMoving == 2:
			if !distancingOnce:
				startDistancing()
				distancingOnce = true
				
			if $virusSpace.get_child_count() == 0:
				virusSpaceMoving = 0
				if !isBossFight:
					virusSpaceWave += 1
				distancingState = 0
				virusWaveJustSpawned = false
				$virusSpawningTimer.start()
				if virusSpaceWave >= 11 and !isBossFight:
					startBossFight()
					$virusSpawningTimer.stop()
					distance_from_center = 280
					$virusSpawningTimer.wait_time = 20
				
			if virusSpaceRotDirection == 0:
				$virusSpace.rotation_degrees += virusSpaceVelocity * delta
			if virusSpaceRotDirection == 1:
				$virusSpace.rotation_degrees -= virusSpaceVelocity * delta
				
		if virusSpaceMoving == 1:
			if !virusWaveJustSpawned:
				if !isBossFight:
					match virusSpaceWave:
						1: 
							spawnWave(
								[viruses[0], 
								viruses[0]], 
								200, 200, 50
								)
						2: 
							spawnWave([
								viruses[0], 
								viruses[0], 
								viruses[0]], 
								200, 200, 55
								)
						3:
							spawnWave(
								[viruses[0], 
								viruses[0], 
								viruses[0], 
								viruses[0]], 
								200, 200, 60
								)
						4:
							spawnLootBox()
							spawnWave(
								[viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1]], 
								200, 200, 50
								)
						5:
							spawnWave(
								[viruses[1], 
								viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1]],
								200, 200, 70)
						6:
							spawnWave(
								[viruses[0], 
								viruses[1], 
								viruses[0], 
								viruses[1],
								viruses[0],
								viruses[1]], 
								200, 200, 50
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
								100, 200, 55
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
								100, 250, 60
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
								100, 300, 65
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
								100, 350, 70
								)
				elif isBossFight == true and !bossInst.health <= 0:
					spawnWave(
						[viruses[4],
						viruses[4]],
						280, 280, 30
						)
					print("teste")
				virusWaveJustSpawned = true
	elif stageFinished == true:
		$CanvasLayer/Label.visible = false
				
func _on_virusSpawningTimer_timeout():
	if virusSpaceMoving == 0:
		virusSpaceMoving = 1
		
func startDistancing():
	$distancingTween.interpolate_property(self, "distance_from_center", distanceFromTo[0], distanceFromTo[1], 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$distancingTween.start()
	
func _on_distancingTween_tween_all_completed():
	distanceFromTo.invert()
	startDistancing()
		
func spawnWave(type_and_amount : Array, distanceF, distanceT, speed):
	distanceFromTo = [distanceF, distanceT]
	
	randomize()
	virusSpaceRotDirection = [0,1][randi() % 2]
	virusSpaceVelocity = speed
	
	for i in type_and_amount.size():
		$virusSpace.add_child(type_and_amount[i].instance())
		
	$virusSpaceMoving.interpolate_property($virusSpace, "position", Vector2(1980, 360), Vector2(1000, 360), 150 / float(virusSpaceVelocity))
	$virusSpaceMoving.start()
	yield($virusSpaceMoving,"tween_all_completed")
	virusSpaceMoving = 2
		
func _on_brokenVirusSpawningTimer_timeout():
	if !isBossFight:
		if virusSpaceMoving == 2:
			add_child(viruses[3].instance())
