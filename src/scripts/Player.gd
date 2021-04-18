extends KinematicBody2D 

var rng = RandomNumberGenerator.new()

const VEL_MAXIMA = 500 
var speed = 400
var move = Vector2()

var hp = 10
var maxhp = 10

var gotHit = false

var existingGun
var gunInstance
var gun2Instance
var gun
var gun2
var slot1Selected = false
var slot2Selected = false
var doesHaveASecondGun = false
var doesHaveAFirstGun = false
var isOverlappingAVirus = false
var slotSelected = 0

func _ready():
	z_index = 3
	z_as_relative = false

func _process(_delta):
	var rotacao = move.x * 0.01
	$col.rotation_degrees = lerp($col.rotation_degrees, rotacao, 1)
	
	var prev_move = move
	move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	move = move.normalized() * speed
	move = move_and_slide(lerp(prev_move, move, 0.02))
		
	if hp >= 10:
		hp = 10
	
	if isOverlappingAVirus == true:
		hit()
		
	if range(GameManager.equippedGuns.size()).has(1) and !GameManager.equippedGuns[1] == null:
		gun2 = GameManager.equippedGuns[1]
	
	if range(GameManager.equippedGuns.size()).has(1) and !GameManager.equippedGuns[1] == null and !doesHaveASecondGun:
		gun2Instance = gun2.instance()
		add_child(gun2Instance)
		doesHaveASecondGun = true
		
	if range(GameManager.equippedGuns.size()).has(0) and !GameManager.equippedGuns[0] == null:
		gun = GameManager.equippedGuns[0]
		
	if range(GameManager.equippedGuns.size()).has(0) and !GameManager.equippedGuns[0] == null and !doesHaveAFirstGun:
		gunInstance = gun.instance()
		add_child(gunInstance)
		doesHaveAFirstGun = true
		
	if doesHaveASecondGun == true and !doesHaveAFirstGun:
		slotSelected = 1
		
	if slotSelected == 0 and !slot1Selected and doesHaveAFirstGun == true:
		if doesHaveASecondGun == true:
			gun2Instance.global_position.x = 0
			gun2Instance.global_position.y = 0
			gun2Instance.set_as_toplevel(true)
		if doesHaveAFirstGun == true:
			gunInstance.position.x = 16
			gunInstance.position.y = 22
			gunInstance.set_as_toplevel(false)
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
		slot1Selected = false
		slot2Selected = true
		
func replace_gun():
	if get_parent().get_node("CanvasLayer").gunSelected == 1:
		gunInstance.queue_free()
		doesHaveAFirstGun = false
		slotSelected = 0
	if get_parent().get_node("CanvasLayer").gunSelected == 2:
		gun2Instance.queue_free()
		doesHaveASecondGun = false
		slotSelected = 1
		
func changeToExistingGun():
	if GameManager.equippedGuns[0] == get_parent().get_node("LootBox").decidedGun:
		if slotSelected == 1:
			slotSelected = 0
	elif GameManager.equippedGuns[1] == get_parent().get_node("LootBox").decidedGun:
		if slotSelected == 0:
			slotSelected = 1
		
func _input(Event):
	if Event.is_action_pressed("ui_accept"):
		if slotSelected == 0:
			if doesHaveAFirstGun == true:
				gunInstance.fire()
		if slotSelected == 1:
			if doesHaveASecondGun == true:
				gun2Instance.fire()
		pass
	if Event.is_action_pressed("ui_selectWeapon0"):
		slotSelected = 0
	elif Event.is_action_pressed("ui_selectWeapon1") and doesHaveASecondGun == true:
		slotSelected = 1

func _on_col_area_entered(area):
	if area.is_in_group("virusBullet"):
		hit()
		
	if area.is_in_group("lootbox"):
		get_parent().get_node("LootBox").gotLootBox()
			
	if area.is_in_group("heart"):
		randomize()
		hp += [1,2][randi() % 2]
	
	if area.is_in_group("virus"):
		isOverlappingAVirus = true
		
func _on_col_area_exited(area):
	if area.is_in_group("virus"):
		isOverlappingAVirus = false
	
func _on_damageCooldown_timeout():
	gotHit = false
	
func hit():
	if !gotHit:
		$playerEffects.play("playerHit")
		hp -= 1
		get_parent().score -= 100
		$damageCooldown.start()
		gotHit = true

