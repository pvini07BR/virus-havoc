extends "res://scripts/viruses/virus.gd"

var randomXPos = 0

func _init():
	direction = Vector2.LEFT

func _ready():
	var randomYPos = rng.randi_range(60, 680)
	randomXPos = rng.randi_range(640, 1245)
	self.position.y = randomYPos
	self.position.x = 1300
	
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
	if get_parent().isBossFight == true:
		stopMoving = false
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
			takeDamage()

func _on_ShootTimer_timeout():
	if vulnerable == true:
		shoot()
		var dir = (get_parent().get_node("player").global_position - global_position).normalized()
		bull.global_rotation = dir.angle() + PI / 2.0
		bull.direction = dir
