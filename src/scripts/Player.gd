extends KinematicBody2D 

var rng = RandomNumberGenerator.new()

const VEL_MAXIMA = 500 
var speed = 400
var move = Vector2()

var hp = 10
var maxhp = 10

var gotHit = false

onready var gun
onready var gun2
onready var existingGun
var slot1Selected = true
var slot2Selected = false
var doesHaveASecondGun = false
var isOverlappingAVirus = false

func _ready():
	gun = GameManager.equippedGuns[0]
	if range(GameManager.equippedGuns.size()).has(1):
		gun2 = GameManager.equippedGuns[1]
		doesHaveASecondGun = true
	add_child(gun.instance())
	
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
		
	existingGun = get_tree().get_nodes_in_group("gun")
	
	if isOverlappingAVirus == true:
		hit()
		
func _input(Event):
	if Event.is_action_pressed("ui_accept"):
		existingGun[0].fire()
	if Event.is_action_pressed("ui_selectWeapon0") and !slot1Selected:
		existingGun[0].queue_free()
		add_child(gun.instance())
		slot1Selected = true
		slot2Selected = false
	elif Event.is_action_pressed("ui_selectWeapon1") and !slot2Selected and doesHaveASecondGun == true:
		existingGun[0].queue_free()
		add_child(gun2.instance())
		slot2Selected = true
		slot1Selected = false

func _on_col_area_entered(area):
	if area.is_in_group("virusBullet"):
		hit()
			
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

