extends Area2D

export var scoreValue: int
export var maxHealth : float
export var shootingCooldownFrom : float
export var shootingCooldownTo : float
export var HeartDropChance : int
export var isInSlot : bool
export var projectile: PackedScene
export var damageSound: AudioStreamSample
export var shootingSound : AudioStreamSample
export var damageAnimation : Animation
export var deathAnimation : Animation

var rng = RandomNumberGenerator.new()
var shooted = false
var vulnerable = false
var canTakeDamage = true
var heartDropProbability = 0
var health : float
var heartDrop = preload("res://scenes/healthHeart.tscn")
var damageIndicator = preload("res://scenes/damageIndicator.tscn")
var droppedHeart = false
var healthBar = TextureProgress.new()
var virusEffects = AnimationPlayer.new()
var damageSoundStream = AudioStreamPlayer.new()
var shootingSoundStream = AudioStreamPlayer.new()
var shootingCooldown = Timer.new()
var damageCooldown = Timer.new()

var bull
var bull2

func _ready():
	health = maxHealth
	
	rng.randomize()
	shootingCooldown.wait_time = rng.randf_range(shootingCooldownFrom, shootingCooldownTo)
	shootingCooldown.connect("timeout", self, "_on_ShootTimer_timeout")
	add_child(shootingCooldown)
	
	damageCooldown.wait_time = 0.1
	damageCooldown.connect("timeout", self, "_on_damageCooldown_timeout")
	add_child(damageCooldown)
	
	healthBar.visible = false
	healthBar.texture_under = load("res://assets/images/viruses/virusBarProgressBg.png")
	healthBar.texture_progress = load("res://assets/images/viruses/virusBarProgress.png")
	healthBar.max_value = maxHealth
	healthBar.rect_pivot_offset = Vector2(19.5,0)
	healthBar.rect_position = Vector2(-19.5,30)
	add_child(healthBar)
	
	virusEffects.add_animation("virusHit", damageAnimation)
	virusEffects.add_animation("virusDeath", deathAnimation)
	virusEffects.connect("animation_finished",self,"_on_virusEffects_animation_finished") 
	add_child(virusEffects)
	
	damageSoundStream.stream = damageSound
	damageSoundStream.volume_db = -10
	add_child(damageSoundStream)
	
	shootingSoundStream.stream = shootingSound
	shootingSoundStream.volume_db = -15
	add_child(shootingSoundStream)
	
	rng.randomize()
	heartDropProbability = rng.randi_range(0, 100)
	
	z_index = 4
	z_as_relative = false

func takeDamageWithCooldown():
	if vulnerable == true:
		if canTakeDamage == true:
			virusEffects.play("virusHit")
			if isInSlot == true:
				if get_parent().get_parent().get_node("player").slotSelected == 0:
					health -= get_parent().get_parent().get_node("player").gunInstance.damage
					var damageIndInst = damageIndicator.instance()
					damageIndInst.amount = get_parent().get_parent().get_node("player").gunInstance.damage
					damageIndInst.type = 0
					get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
					damageIndInst.global_position = global_position
				if get_parent().get_parent().get_node("player").slotSelected == 1:
					health -= get_parent().get_parent().get_node("player").gun2Instance.damage
					var damageIndInst2 = damageIndicator.instance()
					damageIndInst2.amount = get_parent().get_parent().get_node("player").gun2Instance.damage
					damageIndInst2.type = 0
					get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst2)
					damageIndInst2.global_position = global_position
			elif !isInSlot:
				if get_parent().get_node("player").slotSelected == 0:
					health -= get_parent().get_node("player").gunInstance.damage
					var damageIndInst = damageIndicator.instance()
					damageIndInst.amount = get_parent().get_node("player").gunInstance.damage
					damageIndInst.type = 0
					get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
					damageIndInst.global_position = global_position
				if get_parent().get_node("player").slotSelected == 1:
					health -= get_parent().get_node("player").gun2Instance.damage
					var damageIndInst2 = damageIndicator.instance()
					damageIndInst2.amount = get_parent().get_node("player").gun2Instance.damage
					damageIndInst2.type = 0
					get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst2)
					damageIndInst2.global_position = global_position
			damageSoundStream.play()
			healthBar.visible = true
			damageCooldown.start()
			canTakeDamage = false
			
func takeDamage():
	if vulnerable == true:
		virusEffects.play("virusHit")
		if isInSlot == true:
			if get_parent().get_parent().get_node("player").slotSelected == 0:
				health -= get_parent().get_parent().get_node("player").gunInstance.damage
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = get_parent().get_parent().get_node("player").gunInstance.damage
				damageIndInst.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
			if get_parent().get_parent().get_node("player").slotSelected == 1:
				health -= get_parent().get_parent().get_node("player").gun2Instance.damage
				var damageIndInst2 = damageIndicator.instance()
				damageIndInst2.amount = get_parent().get_parent().get_node("player").gun2Instance.damage
				damageIndInst2.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst2)
				damageIndInst2.global_position = global_position
		elif !isInSlot:
			if get_parent().get_node("player").slotSelected == 0:
				health -= get_parent().get_node("player").gunInstance.damage
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = get_parent().get_node("player").gunInstance.damage
				damageIndInst.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
			if get_parent().get_node("player").slotSelected == 1:
				health -= get_parent().get_node("player").gun2Instance.damage
				var damageIndInst2 = damageIndicator.instance()
				damageIndInst2.amount = get_parent().get_node("player").gun2Instance.damage
				damageIndInst2.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst2)
				damageIndInst2.global_position = global_position
		damageSoundStream.play()
		healthBar.visible = true

func shoot():
	if vulnerable == true:
		bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position = global_position
		shootingSoundStream.play()
	
func shoot2():
	if vulnerable == true:
		bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position = global_position
		
		bull2 = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull2)
		bull2.global_position = global_position
		
		shootingSoundStream.play()
		
func _on_virus_area_entered(area):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			takeDamage()
	if area.is_in_group("multiProjectile"):
		if vulnerable == true:
			takeDamageWithCooldown()
		
func _process(_delta):
	healthBar.value = health
	
	if health <= 0:
		if vulnerable == true:
			virusEffects.play("virusDeath")
			healthBar.visible = false
		
			if heartDropProbability >= HeartDropChance and !droppedHeart:
				var heart = heartDrop.instance()
				heart.global_position = global_position
				get_tree().get_nodes_in_group("stage")[0].add_child(heart)
				droppedHeart = true
			vulnerable = false
			
func _on_virusEffects_animation_finished(anim_name):
	if anim_name == "virusDeath":
		if isInSlot == true:
			get_parent().get_parent().virusesKilled += 1
			get_parent().get_parent().score += scoreValue
			queue_free()
		elif !isInSlot:
			get_parent().virusesKilled += 1
			get_parent().score += scoreValue
			queue_free()
		
func _on_damageCooldown_timeout():
	canTakeDamage = true
