extends KinematicBody2D 

var hitSound = preload("res://assets/sounds/playerDamage.wav")
var getHeartSound = preload("res://assets/sounds/heartGet.wav")
var damageIndicator = preload("res://scenes/damageIndicator.tscn")
var victorySprite = preload("res://assets/images/jogadorYeah.png")

var rng = RandomNumberGenerator.new()

var speed = 400
var move = Vector2()

var hp = 10
var maxhp = 10

var gotHit = false

var isOverlappingAVirus = false
var gotHeart = false

export(NodePath) onready var gunsHandler = get_node(gunsHandler) as Node2D

func _ready():
	z_index = 3
	z_as_relative = false

func _physics_process(delta):
	_movement(delta)
	if hp >= 10:
			hp = 10
	if isOverlappingAVirus == true:
		hit(1)
	
		
func _movement(delta):
	var rotate = move.x * 0.7 * delta
	$col.rotation_degrees = lerp($col.rotation_degrees, rotate, 10 * delta)
		
	var prev_move = move
	if GameManager.currentScene.inputWorking == true:
		move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		if GameManager.platform == GameManager.PLATFORMS.MOBILE:
			var joystick = GameManager.currentScene.TouchUInst.joystickButton
			if !joystick.get_value() == Vector2.ZERO:
				move = joystick.get_value()
	else:
		move = Vector2(0, 0)
		
	move = move.normalized() * speed
	move = move_and_slide(lerp(prev_move, move, 10 * delta))
	
	if move.x > 0:
		$col/waves/waveController.playback_speed = lerp(1, move.x / 50, 10 * delta)
	if move.x < -0:
		$col/waves/waveController.playback_speed = lerp(1, -move.x / -20, 10 * delta)
		
func _on_col_area_entered(area):
	if GameManager.currentScene.inputWorking == true:
		if area.is_in_group("virusBullet"):
			hit(area.damage)
				
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
	if GameManager.currentScene.inputWorking == true:
		if area.is_in_group("virus") or area.is_in_group("virusBeam"):
			isOverlappingAVirus = false
	
func hit(damage : int):
	if GameManager.currentScene.inputWorking == true:
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
			yield($damageCooldown,"timeout")
			gotHit = false
			
func _on_stage_ended():
	$col/spr.texture = victorySprite
