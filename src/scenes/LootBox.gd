extends Area2D

var rng = RandomNumberGenerator.new()

var direction : Vector2 = Vector2.LEFT
var speed : float = 300
var hasJustSpawned = true
var stopMoving = false

var randomXPos
var randomYPos

var decidedGun
var boxOpen = false
var howManyGuns = 0

func _ready():	
	$hasJustSpawnedTimer.start()
	if get_parent().GunsInLootBox.empty() == true:
		decidedGun = null
	elif get_parent().GunsInLootBox.size() == 1:
		decidedGun = get_parent().GunsInLootBox[0]
	else:
		randomize()
		decidedGun = get_parent().GunsInLootBox[[0, get_parent().GunsInLootBox.size() - 1][randi() % 2]]
	
	randomize()
	position.x = [-15,1300][randi() % 2]
	position.y = [-15,750][randi() % 2]
	
	rng.randomize()
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
		
func gotLootBox():
	if !boxOpen:
		if get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveASecondGun == true and get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveAFirstGun == true:
			if GameManager.equippedGuns[0] == decidedGun:
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 0
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
			if GameManager.equippedGuns[1] == decidedGun:
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 1
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
			if !GameManager.equippedGuns[0] == decidedGun and !GameManager.equippedGuns[1] == decidedGun:
				get_parent().get_node("LevelUI").isSubAGun = true
				
		if get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveAFirstGun == true and get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveASecondGun == false:
			if GameManager.equippedGuns[0] == decidedGun:
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 0
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
			else:
				GameManager.equippedGuns[1] = decidedGun
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 1
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
				
		if get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveAFirstGun == false and get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveASecondGun == true:
			if GameManager.equippedGuns[1] == decidedGun:
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 1
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
			else:
				GameManager.equippedGuns[0] = decidedGun
				get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 0
				get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
					
		if get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveAFirstGun == false and get_tree().get_nodes_in_group("stage")[0].get_node("player").doesHaveASecondGun == false:
			GameManager.equippedGuns[0] = decidedGun
			get_tree().get_nodes_in_group("stage")[0].get_node("player").slotSelected = 0
			get_tree().get_nodes_in_group("stage")[0].get_node("player").get_node("gunSwitching").play()
				
		stopMoving = true
		$col/AnimationPlayer.stop()
		$col.rotation_degrees = 0
		$col/AnimationPlayer.play("lootBox_open")
		get_parent().obtainedLootBoxBefore = true
		boxOpen = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "lootBox_open":
		$col/AnimationPlayer.play("lootBox_vanish")
	if anim_name == "lootBox_vanish":
		queue_free()

func _on_hasJustSpawnedTimer_timeout():
	hasJustSpawned = false
