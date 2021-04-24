extends "res://scripts/guns/gun.gd"

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
		$cooldownBar.value += 1
	else:
		$cooldownBar.visible = false
		$cooldownBar.value = 0
		
	
func fire():
	if !cooldown:
		if bombExists == true:
			damage = [2,3,4][randi() % 3]
			bom.launch()
			get_parent().get_node("gunShoot").play()
			$cooldown.start()
			cooldown = true

func _on_cooldown_timeout():
	cooldown = false
	if !bombExists:
		bom = projectile.instance()
		add_child(bom)
		bom.position = $bombPos.position
