extends Area2D

export var scoreValue: int
export var maxHealth : float
export var shootingCooldownFrom : float
export var shootingCooldownTo : float
export var HeartDropChance : int
export var projectile: PackedScene
export var damageSounds : Array
export var shootingSound : AudioStreamSample
export var damageAnimation : Animation
export var deathAnimation : Animation

signal onDeath

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
var shootingCooldown = Timer.new()

var bull
var bull2

func _ready():
	health = maxHealth

	if shootingCooldownFrom > 0 and shootingCooldownTo > 0:
		rng.randomize()
		shootingCooldown.wait_time = rng.randf_range(shootingCooldownFrom, shootingCooldownTo)
		shootingCooldown.connect("timeout", self, "_on_ShootTimer_timeout")
		add_child(shootingCooldown)
	
	healthBar.visible = false
	healthBar.texture_under = load("res://assets/images/viruses/virusBarProgressBg.png")
	healthBar.texture_progress = load("res://assets/images/viruses/virusBarProgress.png")
	healthBar.max_value = maxHealth
	healthBar.rect_pivot_offset = Vector2(19.5,0)
	healthBar.rect_position = Vector2(-19.5,30)
	add_child(healthBar)
	
	if !damageAnimation == null:
		virusEffects.add_animation("virusHit", damageAnimation)
	if !deathAnimation == null:
		virusEffects.add_animation("virusDeath", deathAnimation)
		virusEffects.connect("animation_finished",self,"_on_virusEffects_animation_finished")
	else:
		connect("onDeath", self, "_onDeath_triggered") 
	add_child(virusEffects)
	
	rng.randomize()
	heartDropProbability = rng.randi_range(0, 100)
	
	z_index = 4
	z_as_relative = false
	
	add_to_group("virus")
	self.connect("area_entered", self, "_on_virus_area_entered")
			
func takeDamage(cooldown: bool):
	if canTakeDamage == true:
		if vulnerable == true:
			if !damageAnimation == null:
				virusEffects.play("virusHit")
			if get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected == 0:
				health -= get_tree().get_nodes_in_group("stage")[0].get_node("player").gunInstance.damage
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = get_tree().get_nodes_in_group("stage")[0].get_node("player").gunInstance.damage
				damageIndInst.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
			if get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected == 1:
				health -= get_tree().get_nodes_in_group("stage")[0].get_node("player").gun2Instance.damage
				var damageIndInst2 = damageIndicator.instance()
				damageIndInst2.amount = get_tree().get_nodes_in_group("stage")[0].get_node("player").gun2Instance.damage
				damageIndInst2.type = 0
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst2)
				damageIndInst2.global_position = global_position
					
			if !damageSounds.empty():
				randomize()
				rng.randomize()
				SoundManager.playSound(damageSounds[[0,damageSounds.size() - 1][randi() % 2]], -10, rng.randf_range(0.9,1.1))
			healthBar.visible = true
			
		if cooldown == true:
			canTakeDamage = false
			yield(get_tree().create_timer(0.1), "timeout")
			canTakeDamage = true
		
func takeDamageFixedAmount(damage : int):
	if vulnerable == true:
		if !damageAnimation == null:
			virusEffects.play("virusHit")
		health -= damage
		var damageIndInst = damageIndicator.instance()
		damageIndInst.amount = damage
		damageIndInst.type = 0
		get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
		damageIndInst.global_position = global_position
				
		if !damageSounds.empty():
			randomize()
			rng.randomize()
			SoundManager.playSound(damageSounds[[0,damageSounds.size() - 1][randi() % 2]], -10, rng.randf_range(0.9,1.1))
		healthBar.visible = true

func shoot():
	if vulnerable == true:
		bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position = global_position
		if !shootingSound == null:
			SoundManager.playSound(shootingSound, -15, 1)
	
func shoot2():
	if vulnerable == true:
		bull = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull)
		bull.global_position = global_position
		
		bull2 = projectile.instance()
		get_tree().get_nodes_in_group("stage")[0].add_child(bull2)
		bull2.global_position = global_position
		
		if !shootingSound == null:
			SoundManager.playSound(shootingSound, -15, 1)
		
func _on_virus_area_entered(area):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			takeDamage(false)
	if area.is_in_group("multiProjectile"):
		if vulnerable == true:
			takeDamage(true)
	if area.is_in_group("explosion"):
		if vulnerable == true:
			randomize()
			takeDamageFixedAmount([1,2][randi() % 2])
		
func _process(_delta):
	healthBar.value = health
	
	if health <= 0:
		if vulnerable == true:
			if !deathAnimation == null:
				virusEffects.play("virusDeath")
			else:
				emit_signal("onDeath")
			healthBar.visible = false
		
			if heartDropProbability >= HeartDropChance and !droppedHeart:
				var heart = heartDrop.instance()
				heart.global_position = global_position
				get_tree().get_nodes_in_group("stage")[0].add_child(heart)
				droppedHeart = true
			vulnerable = false
			
func _on_virusEffects_animation_finished(anim_name):
	if anim_name == "virusDeath":
		get_tree().get_nodes_in_group("stage")[0].virusesKilled += 1
		get_tree().get_nodes_in_group("stage")[0].score += scoreValue
		queue_free()
			
func _onDeath_triggered():
	get_tree().get_nodes_in_group("stage")[0].virusesKilled += 1
	get_tree().get_nodes_in_group("stage")[0].score += scoreValue
	queue_free()
