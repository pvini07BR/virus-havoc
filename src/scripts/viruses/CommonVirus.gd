extends Area2D

var direction : Vector2 = Vector2.LEFT
var rng = RandomNumberGenerator.new()
var stopMoving = false
var shooted = false
var vulnerable = true
var randomXPos = 0
var virusVelocity = 400
var heartDropProbability = 0
var health = 2
var maxHealth = 2
export var bullet = preload("res://scenes/bullets/virus/VirusBullet.tscn")
export var heartDrop = preload("res://scenes/healthHeart.tscn")

func _ready():
	rng.randomize()
	var randomYPos = rng.randi_range(60, 680)
	randomXPos = rng.randi_range(640, 1245)
	self.position.y = randomYPos
	self.position.x = 1300
	
	heartDropProbability = rng.randi_range(1, 100)
	
	z_index = 4
	z_as_relative = false
	
func _physics_process(_delta):
	if !stopMoving:
		virusVelocity = 400
	else:
		virusVelocity = 0
		if !shooted:
			$ShootTimer.start()
			shooted = true
		
	if self.position.x < randomXPos:
		stopMoving = true
		
func _process(_delta):
	translate(direction*virusVelocity*_delta)
	if health <= 0:
		vulnerable = false
		$virusEffects.play("virusDeath")
		$healthBar.visible = false
		
	$healthBar.value = health
	
	if get_parent().isBossFight == true:
		stopMoving = false
		$ShootTimer.stop()
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()

func _on_CommonVirus_area_entered(area: Area2D):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			$virusEffects.play("virusHit")
			$healthBarAnim.play("healthBarAppear")
			health -= get_tree().get_nodes_in_group("gun")[0].damage


func _on_ShootTimer_timeout():
	var bull = bullet.instance()
	get_tree().get_root().add_child(bull)
	bull.global_position = global_position
	var dir = (get_parent().get_node("player").global_position - global_position).normalized()
	bull.global_rotation = dir.angle() + PI / 2.0
	bull.direction = dir

func _on_virusEffects_animation_finished(anim_name):
	if anim_name == "virusDeath":
		if heartDropProbability >= 90:
			var heart = heartDrop.instance()
			heart.global_position = global_position
			get_tree().get_root().add_child(heart)
		
		get_parent().virusesKilled += 1
		get_parent().score += 100
		queue_free()
