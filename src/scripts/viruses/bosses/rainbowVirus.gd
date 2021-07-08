extends KinematicBody2D

var rng = RandomNumberGenerator.new()

onready var brokenSprite = preload("res://assets/images/viruses/bossVirus_RainbowBroken.png")
onready var damageIndicator = preload("res://scenes/damageIndicator.tscn")
onready var projectile = preload("res://scenes/bullets/virus/rainbowVirusBullet.tscn")
onready var laserBeam = preload("res://scenes/bullets/virus/rainbowVirusDeadlyLaser.tscn")
onready var damageSound = preload("res://assets/sounds/rainbowVirusDamage.wav")
var health = 100
var vulnerable = false
var canTakeDamage = true
var bulletsSpawned = 0

var currentAttack = 0
var prevAttack = 0
var repeatAttack = 0

var timesShooted = 0
var isRamming = false
var isBeaming = false
var isDead = false
var shooted = false

var rammingType
var rammingState = 0
var beamingState = 0
var shootedNrammed = 0

var explosions : int

func _ready():
	position.x = 1760
	position.y = 360
	
	z_index = 4
	z_as_relative = false
	
	$movementTween.interpolate_property(self, "position", Vector2(1760, 360), Vector2(1000, 360), 11.48, Tween.TRANS_LINEAR)
	$movementTween.start()
	
func _on_movementTween_tween_all_completed():
	get_parent().get_node("virusSpawningTimer").start()
	vulnerable = true
	
	attackMoves(1)
	
func attackMoves(attack : int):
	match attack:
		1:
			#shooting
			$shooting.start()
			rng.randomize()
			if !currentAttack == 1:
				repeatAttack = [2,3,4][randi() % 3]
		2:
			#ramming
			rammingType = [0,1][randi() % 2]
			$rammingTween.interpolate_property(self, "position", Vector2(1000, 360), Vector2(-240, 360), 2, Tween.TRANS_LINEAR)
			$rammingTween.start()
			vulnerable = false
			rng.randomize()
			if !currentAttack == 2:
				repeatAttack = [0,1][randi() % 2]
		3:
			#beaming
			$beamingTimer.start()
			$glowIntense.interpolate_property($Area2D/glow, "modulate", Color(1,1,1,0), Color(1,1,1,1),$beamingTimer.wait_time)
			$intensifySpeed.interpolate_property($moving, "playback_speed", 1, 2, $beamingTimer.wait_time)
			$intensifySpeed2.interpolate_property($effects, "playback_speed", 1, 2, $beamingTimer.wait_time)
			$intensifySound.interpolate_property($ambient, "pitch_scale", 1, 2, $beamingTimer.wait_time)
			$intensifySound2.interpolate_property($ambient, "volume_db", -15, -10, $beamingTimer.wait_time)
			$glowIntense.start()
			$intensifySpeed.start()
			$intensifySpeed2.start()
			$intensifySound.start()
			$intensifySound2.start()
			$beamingRiser.play()
			$intensifyBeamingSound.interpolate_property($beamingRiser, "pitch_scale", 1, 2, 5)
			$intensifyBeamingSound2.interpolate_property($beamingRiser, "volume_db", -20, -10, 5)
			$intensifyBeamingSound.start()
			$intensifyBeamingSound2.start()
			if !currentAttack == 3:
				repeatAttack = 0
	currentAttack = attack
			
func randomizeAttack():
	if !isDead:
		randomize()
		if currentAttack == 1:
			attackMoves([2,3][randi() % 2])
		elif currentAttack == 2:
			attackMoves([1,3][randi() % 2])
		elif currentAttack == 3:
			attackMoves([1,2][randi() % 2])

func _on_shooting_timeout():
	if !shooted:
		if vulnerable == true:
			if bulletsSpawned < 11:
				bulletsSpawned += 1
				shoot()
				$shooting.start()
			elif bulletsSpawned >= 11:
				for i in get_tree().get_nodes_in_group("rainbowVirusBullet").size():
					get_tree().get_nodes_in_group("rainbowVirusBullet")[i].moving = true
				$shootingCooldown.start()
				$releasingBullets.play()
				shooted = true
				bulletsSpawned = 0
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("multiProjectile"):
		takeDamage(true)
	if area.is_in_group("projectile"):
		takeDamage(false)
	
func _process(delta):
	if health <= 0:
		die()
		
func shoot():
	if vulnerable == true:
		var bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position.x = global_position.x - 300
		bull.global_position.y = global_position.y + 300 - bulletsSpawned * 55
		
func _on_rammingTween_tween_all_completed():
	rammingState += 1
	if rammingState == 1 and rammingType == 0:
		$rammingTween.interpolate_property(self, "position", Vector2(1760, 360), Vector2(1000, 360), 2, Tween.TRANS_LINEAR)
		$rammingTween.start()
	if rammingState == 1 and rammingType == 1:
		$rammingTween.interpolate_property(self, "position", Vector2(-240, 360), Vector2(1000, 360), 2, Tween.TRANS_LINEAR)
		$rammingTween.start()
	if rammingState == 2:
		#end of the ramming attack
		vulnerable = true
		if !repeatAttack <= 0:
			attackMoves(2)
			repeatAttack -= 1
		else:
			randomizeAttack()
		rammingState = 0
	
func _on_deathDuration_timeout():
	if explosions <= 10:
		var explosion = AnimatedSprite.new()
		var rng = RandomNumberGenerator.new()
		explosion.frames = load("res://animations/explosion.tres")
		explosion.scale = Vector2(0.5, 0.5)
		add_child(explosion)
		rng.randomize()
		explosion.position = Vector2(rng.randf_range(-$Area2D/Sprite.texture.get_size().x / 2, $Area2D/Sprite.texture.get_size().x / 2), rng.randf_range(-$Area2D/Sprite.texture.get_size().y / 2, $Area2D/Sprite.texture.get_size().y / 2))
		explosion.play("default")
		$exploding.play()
		explosions += 1
	else:
		var bigExplosion = AnimatedSprite.new()
		bigExplosion.frames = load("res://animations/explosion.tres")
		bigExplosion.scale = Vector2(3.5, 3.5)
		bigExplosion.set_as_toplevel(true)
		bigExplosion.global_position = global_position
		bigExplosion.z_index = 5
		bigExplosion.z_as_relative = false
		add_child(bigExplosion)
		bigExplosion.play("default")

		$Area2D/Sprite.modulate = Color(1,1,1)
		$moving.play("death")
		$effects.playback_speed = 0.5
		$Area2D/Sprite.texture = brokenSprite
		$deathTween.interpolate_property(self, "position", Vector2(1000, 360), Vector2(1000, 1000), 5, Tween.TRANS_LINEAR)
		$deathTween.start()
		$deathSound.play()
		$deathDuration.stop()
		
func takeDamage(cooldown : bool):
	if canTakeDamage == true:
		if vulnerable == true:
			if get_parent().get_node("player").slotSelected == 0:
				health -= get_parent().get_node("player").gunInstance.damage
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = get_parent().get_node("player").gunInstance.damage
				damageIndInst.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
			if get_parent().get_node("player").slotSelected == 1:
				health -= get_parent().get_node("player").gun2Instance.damage
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = get_parent().get_node("player").gun2Instance.damage
				damageIndInst.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
			$damage.play("damage")
			SoundManager.playSound(damageSound, 0, 1)
			
		if cooldown == true:
			canTakeDamage = false
			yield(get_tree().create_timer(0.1), "timeout")
			canTakeDamage = true
			
func die():
	if !isDead:
		vulnerable = false
		health = 0
		get_tree().get_root().get_node("GameManager/musicChannel").set_stream(null)
		$ambient.stop()
		$Area2D/glow.visible = false
		$moving.playback_speed = 1
		$moving.stop()
		$deathDuration.start()
		$Area2D/Sprite.modulate = Color(1,0.6,0.6)
		$beamingRiser.stop()
		
		$damageCooldown.stop()
		$shootingCooldown.stop()
		$beamingTimer.stop()
		currentAttack = 0
		repeatAttack = 0
		isDead = true
			
func _on_damageCooldown_timeout():
	canTakeDamage = true

func _on_shootingCooldown_timeout():
	#end of the shooting attack
	shooted = false
	if !repeatAttack <= 0:
		attackMoves(1)
		repeatAttack -= 1
	else:
		randomizeAttack()
	
func _on_beamingTimer_timeout():
	if beamingState == 0:
		add_child(laserBeam.instance())
		beamingState = 1
		$beamingTimer.start()
	if beamingState == 1:
		$glowIntense.interpolate_property($Area2D/glow, "modulate", Color(1,1,1,1), Color(1,1,1,0),$beamingTimer.wait_time / 2)
		$intensifySpeed.interpolate_property($moving, "playback_speed", 2, 1, $beamingTimer.wait_time / 2)
		$intensifySpeed2.interpolate_property($effects, "playback_speed", 2, 1, $beamingTimer.wait_time / 2)
		$intensifySound.interpolate_property($ambient, "pitch_scale", 2, 1, $beamingTimer.wait_time / 2)
		$intensifySound2.interpolate_property($ambient, "volume_db", -10, -15, $beamingTimer.wait_time / 2)
		$glowIntense.start()
		$intensifySpeed.start()
		$intensifySpeed2.start()
		$intensifySound.start()
		$intensifySound2.start()
		$beamingRiser.volume_db = -20
		$beamingRiser.pitch_scale = 1
	
func _on_intensifyBeamingSound_tween_all_completed():
	$beamingRiser.stop()
		
func _on_deathTween_tween_all_completed():
	get_parent().endStage()
