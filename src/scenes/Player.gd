extends KinematicBody2D 

onready var hitSound = preload("res://assets/sounds/playerDamage.wav")
onready var getHeartSound = preload("res://assets/sounds/heartGet.wav")
onready var damageIndicator = preload("res://scenes/damageIndicator.tscn")
onready var victorySprite = preload("res://assets/images/jogadorYeah.png")

var rng = RandomNumberGenerator.new()

var speed = 400
var move = Vector2()

var slot1Equipped = false
var slot2Equipped = false

var hp = 10
var maxhp = 10

var gotHit = false

var cameFromInput
var existingGun
var gunInstance
var gun2Instance
var doesHaveASecondGun = false
var doesHaveAFirstGun = false
var isOverlappingAVirus = false
var slotSelected = 0
var gotHeart = false

var isInputWorking = false

func _ready():
	z_index = 3
	z_as_relative = false

func _physics_process(delta):
	var rotate = move.x * 0.7 * delta
	$col.rotation_degrees = lerp($col.rotation_degrees, rotate, 10 * delta)
		
	var prev_move = move
	if isInputWorking == true:
		move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	else:
		if !get_parent().stageBegun:
			pass
		else:
			move = Vector2(0, 0)
		
	move = move.normalized() * speed
	move = move_and_slide(lerp(prev_move, move, 10 * delta))
	
	if move.x > 0:
		$col/waves/waveController.playback_speed = lerp(1, move.x / 50, 10 * delta)
	if move.x < -0:
		$col/waves/waveController.playback_speed = lerp(1, -move.x / -20, 10 * delta)

func _process(_delta):
	if get_parent().stageFinished == true and !isInputWorking:
		$col/spr.texture = victorySprite
	
	#sistema de armas
	if range(GameManager.equippedGuns.size()).has(1) and !GameManager.equippedGuns[1] == null and !doesHaveASecondGun:
		gun2Instance = GameManager.equippedGuns[1].instance()
		add_child(gun2Instance)
		doesHaveASecondGun = true
			
	if range(GameManager.equippedGuns.size()).has(0) and !GameManager.equippedGuns[0] == null and !doesHaveAFirstGun:
		gunInstance = GameManager.equippedGuns[0].instance()
		add_child(gunInstance)
		doesHaveAFirstGun = true
			
	if doesHaveASecondGun == true and !doesHaveAFirstGun:
		slotSelected = 1
	if !doesHaveASecondGun and doesHaveAFirstGun == true:
		slotSelected = 0
			
	if slotSelected == 0 and doesHaveAFirstGun == true and !slot1Equipped:
		if doesHaveASecondGun == true:
			gun2Instance.position.x = 16
			gun2Instance.position.y = 22
			gun2Instance.visible = false
			gun2Instance.active = false
		if doesHaveAFirstGun == true:
			gunInstance.position.x = 16
			gunInstance.position.y = 22
			gunInstance.visible = true
			gunInstance.active = true
		if cameFromInput == true:
			$gunSwitching.play()
			cameFromInput = false
		slot1Equipped = true
		slot2Equipped = false
	if slotSelected == 1 and doesHaveASecondGun == true and !slot2Equipped:
		if doesHaveAFirstGun == true:
			gunInstance.position.x = 16
			gunInstance.position.y = 22
			gunInstance.visible = false
			gunInstance.active = false
		if doesHaveASecondGun == true:
			gun2Instance.position.x = 16
			gun2Instance.position.y = 22
			gun2Instance.visible = true
			gun2Instance.active = true
		if cameFromInput == true:
			$gunSwitching.play()
			cameFromInput = false
		slot2Equipped = true
		slot1Equipped = false
			
	if hp >= 10:
			hp = 10
	if isOverlappingAVirus == true:
		hit(1)
			
func replace_gun():
	if get_parent().get_node("LevelUI").gunSelected == 1:
		$gunSwitching.play()
		gunInstance.queue_free()
		doesHaveAFirstGun = false
		slot1Equipped = false
		slotSelected = 0
	if get_parent().get_node("LevelUI").gunSelected == 2:
		$gunSwitching.play()
		gun2Instance.queue_free()
		doesHaveASecondGun = false
		slot2Equipped = false
		slotSelected = 1
		
func changeToExistingGun():
	if GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
		if slotSelected == 1:
			slotSelected = 0
	elif GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun:
		if slotSelected == 0:
			slotSelected = 1
		
func _input(Event):
	if isInputWorking == true:
		if Event.is_action_pressed("ui_selectWeapon0") and doesHaveAFirstGun == true:
			cameFromInput = true
			slotSelected = 0
		elif Event.is_action_pressed("ui_selectWeapon1") and doesHaveASecondGun == true:
			cameFromInput = true
			slotSelected = 1

func _on_col_area_entered(area):
	if isInputWorking == true:
		if area.is_in_group("virusBullet"):
			hit(1)
			
		if area.is_in_group("explosion"):
			randomize()
			hit([1,2][randi() % 2])
				
		if area.is_in_group("lootbox"):
			get_parent().get_node("LootBox").gotLootBox()
				
		if area.is_in_group("heart"):
			if hp < 10 and !gotHeart:
				SoundManager.playSound(getHeartSound, -5, 1)
				randomize()
				var heal = [1,2][randi() % 2]
				hp += heal
					
				var damageIndInst = damageIndicator.instance()
				damageIndInst.amount = heal
				damageIndInst.type = 1
				get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
				damageIndInst.global_position = global_position
				gotHeart = true
			
		if area.is_in_group("virus") or area.is_in_group("virusBeam"):
			isOverlappingAVirus = true
		
func _on_col_area_exited(area):
	if isInputWorking == true:
		if area.is_in_group("virus") or area.is_in_group("virusBeam"):
			isOverlappingAVirus = false
	
func _on_damageCooldown_timeout():
	gotHit = false
	
func hit(damage : int):
	if isInputWorking == true:
		if !gotHit:
			SoundManager.playSound(hitSound, -10, 1)
			
			$playerEffects.play("playerHit")
			hp -= damage
			get_parent().score -= damage * 100
			$damageCooldown.start()
			
			var damageIndInst = damageIndicator.instance()
			damageIndInst.amount = damage
			damageIndInst.type = 2
			get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
			damageIndInst.global_position = global_position
			gotHit = true
