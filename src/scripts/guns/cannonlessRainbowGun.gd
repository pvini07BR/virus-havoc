extends "res://scripts/bases/gun.gd"

var shooted = false
var shootingState = 0
var bulletsSpawned = 0
var pressed = false

func _ready():
	$rainbowEffect.interpolate_property($sprite.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.interpolate_property($ray.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.interpolate_property($raytracing.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.start()

func _process(_delta):
	if !active and !shooted and pressed == true:
		for i in get_tree().get_nodes_in_group("rainbowBullet").size():
			get_tree().get_nodes_in_group("rainbowBullet")[i].moving = true
		shootingState = 0
		bulletsSpawned = 0
		$shootingCooldown.start()
		$release.play()
		pressed = false
		shooted = true
		
	if pressed == true:
		$ray.playing = true
		$ray.visible = true
		$raytracing.visible = true
		$active.playing = true
	elif pressed == false:
		$ray.playing = false
		$ray.visible = false
		$raytracing.visible = false
		$active.playing = false
	
	if shootingState == 2 and !shooted:
		for i in get_tree().get_nodes_in_group("rainbowBullet").size():
			get_tree().get_nodes_in_group("rainbowBullet")[i].moving = true
		shootingState = 0
		bulletsSpawned = 0
		$shootingCooldown.start()
		shooted = true
		
func shoot():
	if !pressed:
		pressed = true
	if !shooted:
		var bull = projectile.instance()
		add_child(bull)
		bull.set_as_toplevel(true)
		bull.global_position.y = 640 - bulletsSpawned * 63
		bull.global_position.x = global_position.x + 300
		bulletsSpawned += 1

func _input(event):
	if active == true:
		if !get_parent().get_parent().stageFinished:
			if event.is_action_pressed("ui_accept"):
				if !pressed:
					if !shooted:
						shootingState += 1
			if !shooted:
				if event.is_action_released("ui_accept"):
					if pressed == true:
						shootingState += 1
						$release.play()
						pressed = false

func _on_cooldown_timeout():
	if !shooted:
		if shootingState == 1:
			if !bulletsSpawned >= 10:
				shoot()

func _on_shootingCooldown_timeout():
	if shooted == true:
		shooted = false
