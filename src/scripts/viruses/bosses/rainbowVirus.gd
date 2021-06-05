extends KinematicBody2D

onready var brokenSprite = preload("res://assets/images/viruses/bossVirus_RainbowBroken.png")
onready var damageIndicator = preload("res://scenes/damageIndicator.tscn")
onready var projectile = preload("res://scenes/bullets/virus/rainbowVirusBullet.tscn")
onready var laserBeam = preload("res://scenes/bullets/virus/rainbowVirusDeadlyLaser.tscn")
var health = 100
var vulnerable = false
var canTakeDamage = true
var bulletsSpawned = 0
var timesShooted = 0
var isRamming = false
var isBeaming = false
var shooted = false
var rammingState = 0
var beamingState = 0
var shootedNrammed = 0

func _ready():
	position.x = 1760
	position.y = 360
	
	z_index = 4
	z_as_relative = false
	
	$deathTween.interpolate_property(self, "position", Vector2(1000, 360), Vector2(1000, 1000), 5, Tween.TRANS_LINEAR)
	$movementTween.interpolate_property(self, "position", Vector2(1760, 360), Vector2(1000, 360), 12.1, Tween.TRANS_LINEAR)
	$movementTween.start()
	
func _physics_process(_delta):
	if timesShooted >= 5:
		isRamming = true
		
	if rammingState == 2:
		isRamming = false
		vulnerable = true
		timesShooted = 0
		if !shootedNrammed == 5:
			shootedNrammed += 1
		elif shootedNrammed == 5 and !isBeaming:
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
			beamingState = 0
			isBeaming = true
		rammingState = 0
		
	if isRamming == true and !shooted and vulnerable == true and !isBeaming:
		$rammingTween.interpolate_property(self, "position", Vector2(1000, 360), Vector2(-240, 360), 2, Tween.TRANS_LINEAR)
		$rammingTween.start()
		#direction = Vector2.LEFT
		#velocity = 500
		vulnerable = false
	
	if bulletsSpawned >= 11:
		for i in get_tree().get_nodes_in_group("rainbowVirusBullet").size():
			get_tree().get_nodes_in_group("rainbowVirusBullet")[i].moving = true
		$shootingCooldown.start()
		$releasingBullets.play()
		shooted = true
		bulletsSpawned = 0
		if !isRamming:
			timesShooted += 1
			
	if health <= 0:
		vulnerable = false
		#direction = Vector2.DOWN
		#velocity = 500
		health = 0
		$ambient.stop()
		$Area2D/Sprite.texture = brokenSprite
		$Area2D/glow.visible = false
		$moving.playback_speed = 1
		$moving.play("death")
		$effects.playback_speed = 0.5
		
		$deathTween.start()
		
func shoot():
	if vulnerable == true:
		var bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position.x = global_position.x - 300
		bull.global_position.y = global_position.y + 300 - bulletsSpawned * 55

func _on_Area2D_area_entered(area):
	if area.is_in_group("multiProjectile"):
		if vulnerable == true:
			if canTakeDamage == true:
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
				$damageS.play()
				$damageCooldown.start()
				canTakeDamage = false
	if area.is_in_group("projectile"):
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
			$damageS.play()

func _on_shooting_timeout():
	if !shooted:
		if vulnerable == true and !isBeaming:
			bulletsSpawned += 1
			if !bulletsSpawned >= 11:
				$shooting.start()
			if !bulletsSpawned >= 10:
				shoot()

func _on_movementTween_tween_all_completed():
	vulnerable = true

func _on_rammingTween_tween_all_completed():
	rammingState += 1
	if rammingState == 1:
		$rammingTween.interpolate_property(self, "position", Vector2(1760, 360), Vector2(1000, 360), 2, Tween.TRANS_LINEAR)
		$rammingTween.start()

func _on_damageCooldown_timeout():
	canTakeDamage = true

func _on_shootingCooldown_timeout():
	shooted = false

func _on_beamingTimer_timeout():
	if isBeaming == true:
		if beamingState == 0:
			add_child(laserBeam.instance())
		if beamingState == 1:
			shootedNrammed = 0
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
			isBeaming = false
		beamingState += 1

func _on_intensifyBeamingSound_tween_all_completed():
	$beamingRiser.stop()
