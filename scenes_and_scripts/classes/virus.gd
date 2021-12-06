extends Area2D

class_name Virus

export(int) var scoreValue
export(float) var maxHealth
export(float) var shootingCooldownFrom
export(float) var shootingCooldownTo
export(int) var HeartDropChance
export(PackedScene) var projectile
export(Array, AudioStreamSample) var damageSounds
export(AudioStreamSample) var shootingSound
export(Animation) var damageAnimation
export(Animation) var deathAnimation

signal onDeath

var rng = RandomNumberGenerator.new()
var shooted = false
var vulnerable = false
var canTakeDamage = true
var heartDropProbability = 0
var health : float
var heartDrop = preload("res://scenes_and_scripts/entities/pickups/healthHeart/healthHeart.tscn")
var damageIndicator = preload("res://scenes_and_scripts/entities/damageIndicator.tscn")
var droppedHeart = false
var healthBar = ProgressBar.new()
var virusEffects = AnimationPlayer.new()
var shootingCooldown = Timer.new()

func _ready():
	health = maxHealth

	if shootingCooldownFrom > 0 and shootingCooldownTo > 0:
		rng.randomize()
		shootingCooldown.wait_time = rng.randf_range(shootingCooldownFrom, shootingCooldownTo)
		shootingCooldown.connect("timeout", self, "_on_ShootTimer_timeout")
		add_child(shootingCooldown)
	
	healthBar.visible = false
	healthBar.percent_visible = false
	healthBar.max_value = maxHealth
	healthBar.rect_position = Vector2(-25, 25)
	healthBar.rect_size = Vector2(50, 5)
	add_child(healthBar)
	var styleBoxFlat = StyleBoxFlat.new()
	var styleBoxFlat2 = StyleBoxFlat.new()
	
	styleBoxFlat.corner_radius_bottom_left = 5
	styleBoxFlat.corner_radius_bottom_right = 5
	styleBoxFlat.corner_radius_top_left = 5
	styleBoxFlat.corner_radius_top_right = 5
	
	styleBoxFlat2.corner_radius_bottom_left = 5
	styleBoxFlat2.corner_radius_bottom_right = 5
	styleBoxFlat2.corner_radius_top_left = 5
	styleBoxFlat2.corner_radius_top_right = 5
	
	styleBoxFlat2.bg_color = Color(0, 1, 0, 1)
	
	healthBar.set("custom_styles/bg", styleBoxFlat)
	healthBar.set("custom_styles/fg", styleBoxFlat2)
	
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
		
func hit(damage : int, cooldown : bool):
	if canTakeDamage == true:
		if vulnerable == true:
			if !damageAnimation == null:
				virusEffects.play("virusHit")
			health -= damage
			var damageIndInst = damageIndicator.instance()
			damageIndInst.amount = damage
			damageIndInst.type = 0
			GameManager.currentScene.add_child(damageIndInst)
			damageIndInst.global_position = global_position
					
			if !damageSounds.empty():
				randomize()
				rng.randomize()
				SoundManager.playSound(damageSounds[[0,damageSounds.size() - 1][randi() % 2]], -10, rng.randf_range(0.9,1.1))
			healthBar.visible = true
			
		if cooldown == true:
			canTakeDamage = false
			yield(get_tree().create_timer(0.1), "timeout")
			canTakeDamage = true
		
func _on_virus_area_entered(area):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			hit(area.damage, false)
	if area.is_in_group("multiProjectile"):
		if vulnerable == true:
			hit(area.damage, true)
		
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
