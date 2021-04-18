extends Area2D

var rng = RandomNumberGenerator.new()

var direction : Vector2 = Vector2.LEFT
var speed : float = 300
var hasJustSpawned = true
var stopMoving = false

var randomXPos
var randomYPos

var gunsInTheBox = {
	one = GameManager.guns.values()[1],
	two = GameManager.guns.values()[2]
}

var whatGunDecided = 0
var decidedGun
var boxOpen = false
var howManyGuns = 0

func _ready():
	$hasJustSpawnedTimer.start()
	randomize()
	rng.randomize()
	whatGunDecided = [1, 2][randi() % 2]
	
	position.x = [-15,1300][randi() % 2]
	position.y = [-15,750][randi() % 2]
	
	$randomPointPos.set_as_toplevel(true)
	$randomPointPos.global_position.x = rng.randi_range(-15,1300)
	$randomPointPos.global_position.y = rng.randi_range(-15,750)
	
	z_index = 1
	z_as_relative = false
	
	var dir = ($randomPointPos.global_position - global_position).normalized()
	direction = dir
	
func _physics_process(_delta):
	if !hasJustSpawned:
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()
	
func _process(_delta):
	if !stopMoving:
		translate(direction*speed*_delta)
	
	if whatGunDecided == 1:
		decidedGun = gunsInTheBox["one"]
	elif whatGunDecided == 2:
		decidedGun = gunsInTheBox["two"]
		
func gotLootBox():
	if !boxOpen:
		if get_parent().get_node("player").doesHaveASecondGun == true and get_parent().get_node("player").doesHaveAFirstGun == true:
			get_parent().get_node("CanvasLayer").isSubAGun = true
		else:
			if get_parent().get_node("player").doesHaveAFirstGun == true:
				if GameManager.equippedGuns[0] == decidedGun:
					pass
				else:
					GameManager.equippedGuns[1] = decidedGun
					get_parent().get_node("player").slotSelected = 1
			else:
				GameManager.equippedGuns[0] = decidedGun
				get_parent().get_node("player").slotSelected = 0
		stopMoving = true
		$col/AnimationPlayer.stop()
		$col.rotation_degrees = 0
		$col/AnimationPlayer.play("lootBox_open")
		boxOpen = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "lootBox_open":
		$col/AnimationPlayer.play("lootBox_vanish")
	if anim_name == "lootBox_vanish":
		queue_free()

func _on_hasJustSpawnedTimer_timeout():
	hasJustSpawned = false
