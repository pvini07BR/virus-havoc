extends Area2D

var rng = RandomNumberGenerator.new()
var stopMoving = false
var shooted = false
var randomXPos = 0
var virusVelocity = 5
var health = 4
var maxHealth = 4
export var bullet = preload("res://scenes/VirusBullet.tscn")

func _ready():
	rng.randomize()
	var randomYPos = rng.randi_range(60, 680)
	randomXPos = rng.randi_range(640, 1245)
	self.position.y = randomYPos
	self.position.x = 1300
	
func _physics_process(_delta):
	if !stopMoving:
		virusVelocity = 5
		self.position.x -= virusVelocity
	else:
		virusVelocity = 0
		self.position.x -= virusVelocity
		if !shooted:
			$ShootTimer.start()
			shooted = true
		
	if self.position.x < randomXPos:
		stopMoving = true
		
func _process(_delta):
	if health == 0:
		get_parent().virusesKilled += 1
		queue_free()
		
	$healthBar.value = health

func _on_CommonVirus_area_entered(area: Area2D):
	if area.is_in_group("tiro"):
		$virusEffects.play("virusHit")
		$healthBarAnim.play("healthBarAppear")
		health -= 1


func _on_ShootTimer_timeout():
	var bull = bullet.instance()
	get_tree().get_root().add_child(bull)
	bull.global_position = global_position
	var dir = (get_parent().get_node("player").global_position - global_position).normalized()
	bull.global_rotation = dir.angle() + PI / 2.0
	bull.direction = dir
	$DoubleLaserTimer.start()

func _on_DoubleLaserTimer_timeout():
	var bull = bullet.instance()
	get_tree().get_root().add_child(bull)
	bull.global_position = global_position
	var dir = (get_parent().get_node("player").global_position - global_position).normalized()
	bull.global_rotation = dir.angle() + PI / 2.0
	bull.direction = dir
