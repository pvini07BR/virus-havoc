extends Area2D

var rng = RandomNumberGenerator.new()
var direction: Vector2
var stopMoving = false
var shooted = false
var vulnerable = true
var virusVelocity: int
var heartDropProbability = 0
export var health: float
export var scoreValue: int
var maxHealth = health
var heartDrop = preload("res://scenes/healthHeart.tscn")
export var projectile: PackedScene
export var damageSound: AudioStreamSample

var bull
var bull2

func _ready():
	rng.randomize()
	heartDropProbability = rng.randi_range(1, 100)
	
	z_index = 4
	z_as_relative = false

func takeDamage():
	$virusEffects.play("virusHit")
	$healthBarAnim.play("healthBarAppear")
	if get_parent().get_node("player").slotSelected == 0:
		health -= get_parent().get_node("player").gunInstance.damage
	if get_parent().get_node("player").slotSelected == 1:
		health -= get_parent().get_node("player").gun2Instance.damage
	$damage.play()

func shoot():
	bull = projectile.instance()
	get_tree().get_nodes_in_group("level")[0].add_child(bull)
	bull.global_position = global_position
	$shooting.play()
	
func shoot2():
	bull = projectile.instance()
	get_tree().get_nodes_in_group("level")[0].add_child(bull)
	bull.global_position = global_position
	
	bull2 = projectile.instance()
	get_tree().get_nodes_in_group("level")[0].add_child(bull2)
	bull2.global_position = global_position
	
	$shooting.play()
func _process(_delta):
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
			
	if health <= 0:
		vulnerable = false
		$virusEffects.play("virusDeath")
		$healthBar.visible = false
			
func _on_virusEffects_animation_finished(anim_name):
	if anim_name == "virusDeath":
		if heartDropProbability >= 90:
			var heart = heartDrop.instance()
			heart.global_position = global_position
			get_tree().get_nodes_in_group("level")[0].add_child(heart)
		
		get_parent().virusesKilled += 1
		get_parent().score += scoreValue
		queue_free()
