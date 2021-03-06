extends "res://scripts/bases/gun.gd"

var bombExists = false
var bom

func _ready():
	position = get_node("../gunPos").position
	bom = projectile.instance()
	add_child(bom)
	bom.position = $bombPos.position
	
	z_index = 2
	z_as_relative = false
	
func _process(_delta):
	if !bombExists:
		$cooldownBar.visible = true
		$cooldownBar.value = $cooldown.time_left
	else:
		$cooldownBar.visible = false
		$cooldownBar.value = 0
		
	
func _input(Event):
	if get_parent().isInputWorking == true:
		if active == true:
			if Event.is_action_pressed("ui_accept"):
				if !cooldown:
					if bombExists == true:
						damage = [2,3,4][randi() % 3]
						bom.launch()
						if !shootingSound == null:
							SoundManager.playSound(shootingSound, -10, 1)
						$cooldown.start()
						cooldown = true

func _on_cooldown_timeout():
	cooldown = false
	if !bombExists:
		bom = projectile.instance()
		add_child(bom)
		bom.position = $bombPos.position
