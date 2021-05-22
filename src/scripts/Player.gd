extends KinematicBody2D 

onready var hitSound = load("res://assets/sounds/playerDamage.wav")
onready var damageIndicator = preload("res://scenes/damageIndicator.tscn")

var rng = RandomNumberGenerator.new()

var speed = 400
var move = Vector2()

var hp = 10
var maxhp = 10

var gotHit = false

var cameFromInput
var existingGun
var gunInstance
var gun2Instance
var slot1Selected = false
var slot2Selected = false
var doesHaveASecondGun = false
var doesHaveAFirstGun = false
var isOverlappingAVirus = false
var slotSelected = 0
var gotHeart = false

func _ready():
	z_index = 3
	z_as_relative = false

func _physics_process(delta):
	if !get_parent().stageFinished:
		var rotate = move.x * 0.7 * delta
		$col.rotation_degrees = lerp($col.rotation_degrees, rotate, 10 * delta)
		
		var prev_move = move
		move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		
		move = move.normalized() * speed
		move = move_and_slide(lerp(prev_move, move, 10 * delta))
	
	if move.x > 0:
		$col/waves/waveController.playback_speed = lerp(1, move.x / 50, 10 * delta)
	if move.x < -0:
		$col/waves/waveController.playback_speed = lerp(1, -move.x / -20, 10 * delta)

func _process(delta):
	if !get_parent().stageFinished:
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
			
		if slotSelected == 0 and !slot1Selected and doesHaveAFirstGun == true:
			if doesHaveASecondGun == true:
				gun2Instance.global_position.x = 0
				gun2Instance.global_position.y = 0
				gun2Instance.set_as_toplevel(true)
			if doesHaveAFirstGun == true:
				gunInstance.position.x = 16
				gunInstance.position.y = 22
				gunInstance.set_as_toplevel(false)
			if cameFromInput == true:
				$gunSwitching.play()
				cameFromInput = false
			$gunShoot.stream = gunInstance.shootingSound
			slot1Selected = true
			slot2Selected = false
		if slotSelected == 1 and !slot2Selected and doesHaveASecondGun == true:
			if doesHaveAFirstGun == true:
				gunInstance.global_position.x = 0
				gunInstance.global_position.y = 0
				gunInstance.set_as_toplevel(true)
			if doesHaveASecondGun == true:
				gun2Instance.position.x = 16
				gun2Instance.position.y = 22
				gun2Instance.set_as_toplevel(false)
			if cameFromInput == true:
				$gunSwitching.play()
				cameFromInput = false
			$gunShoot.stream = gun2Instance.shootingSound
			slot1Selected = false
			slot2Selected = true
			
		if hp >= 10:
				hp = 10
		if isOverlappingAVirus == true:
			hit()
			
func replace_gun():
	if !get_parent().stageFinished:
		if get_parent().get_node("LevelUI").gunSelected == 1:
			$gunSwitching.play()
			gunInstance.queue_free()
			doesHaveAFirstGun = false
			slotSelected = 0
		if get_parent().get_node("LevelUI").gunSelected == 2:
			$gunSwitching.play()
			gun2Instance.queue_free()
			doesHaveASecondGun = false
			slotSelected = 1
		
func changeToExistingGun():
	if !get_parent().stageFinished:
		if GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
			if slotSelected == 1:
				slotSelected = 0
		elif GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun:
			if slotSelected == 0:
				slotSelected = 1
		
func _input(Event):
	if !get_parent().stageFinished:
		if Event.is_action_pressed("ui_accept"):
			if slotSelected == 0:
				if doesHaveAFirstGun == true:
					gunInstance.fire()
			if slotSelected == 1:
				if doesHaveASecondGun == true:
					gun2Instance.fire()
		if Event.is_action_pressed("ui_selectWeapon0") and doesHaveAFirstGun == true:
			cameFromInput = true
			slotSelected = 0
		elif Event.is_action_pressed("ui_selectWeapon1") and doesHaveASecondGun == true:
			cameFromInput = true
			slotSelected = 1

func _on_col_area_entered(area):
	if !get_parent().stageFinished:
		if area.is_in_group("virusBullet"):
			hit()
			
		if area.is_in_group("lootbox"):
			get_parent().get_node("LootBox").gotLootBox()
				
		if area.is_in_group("heart"):
			if hp < 10 and !gotHeart:
				$getHeart.play()
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
	if !get_parent().stageFinished:
		if area.is_in_group("virus") or area.is_in_group("virusBeam"):
			isOverlappingAVirus = false
	
func _on_damageCooldown_timeout():
	if !get_parent().stageFinished:
		gotHit = false
	
func hit():
	if !get_parent().stageFinished:
		if !gotHit:
			$Hits.play()
			
			$playerEffects.play("playerHit")
			hp -= 1
			get_parent().score -= 100
			$damageCooldown.start()
			
			var damageIndInst = damageIndicator.instance()
			damageIndInst.amount = 1
			damageIndInst.type = 2
			get_tree().get_nodes_in_group("stage")[0].add_child(damageIndInst)
			damageIndInst.global_position = global_position
			gotHit = true
