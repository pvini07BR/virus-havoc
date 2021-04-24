extends "res://scripts/viruses/virus.gd"

var randomXPos = 0
var willRamIntoPlayer = 0
var isRamming = false

func _init():
	direction = Vector2.LEFT
	virusVelocity = 400

func _ready():
	randomize()
	willRamIntoPlayer = [0,1][randi() % 2]
	$ShootTimer.wait_time = [2,4][randi() % 2]
	
	var randomYPos = rng.randi_range(60, 680)
	randomXPos = rng.randi_range(640, 1245)
	self.position.y = randomYPos
	self.position.x = 1300
	
func _physics_process(_delta):
	if virusVelocity == 0 and !shooted:
		$ShootTimer.start()
		shooted = true
		
	if position.x < randomXPos and !isRamming:
		virusVelocity = 0
		if !get_parent().isBossFight:
			if willRamIntoPlayer == 1:
				$RammingTimer.start()
				isRamming = true
		
func _process(_delta):
	translate(direction*virusVelocity*_delta)
	if get_parent().isBossFight == true:
		virusVelocity = 400
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()
			
	if isRamming == true:
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()

func _on_DualLaserVirus_area_entered(area):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			takeDamage()

func _on_ShootTimer_timeout():
	if vulnerable == true:
		shoot()
		var dir = (get_parent().get_node("player").global_position - global_position).normalized()
		bull.global_rotation = dir.angle() + PI / 2.0
		bull.direction = dir
		$DoubleLaserTimer.start()

func _on_DoubleLaserTimer_timeout():
	if vulnerable == true:
		shoot()
		var dir = (get_parent().get_node("player").global_position - global_position).normalized()
		bull.global_rotation = dir.angle() + PI / 2.0
		bull.direction = dir

func _on_RammingTimer_timeout():
	if !get_parent().isBossFight:
		virusVelocity = 750
		vulnerable = false
		var dir = (get_parent().get_node("player").global_position - global_position).normalized()
		direction = dir
