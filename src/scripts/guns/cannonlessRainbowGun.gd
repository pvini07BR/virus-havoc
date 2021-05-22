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

func _process(delta):
	if pressed == true:
		$ray.playing = true
		$ray.visible = true
		$raytracing.visible = true
	elif pressed == false:
		$ray.playing = false
		$ray.visible = false
		$raytracing.visible = false
	
	if shootingState == 2 and !shooted:
		for i in get_tree().get_nodes_in_group("rainbowBullet").size():
			get_tree().get_nodes_in_group("rainbowBullet")[i].moving = true
		shootingState = 0
		bulletsSpawned = 0
		$shootingCooldown.start()
		shooted = true

func fire():
	if !shooted:
		shootingState += 1
		
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
	if !shooted:
		if event.is_action_released("ui_accept"):
			if pressed == true:
				shootingState += 1
				pressed = false

func _on_cooldown_timeout():
	if !shooted:
		if shootingState == 1:
			if !bulletsSpawned >= 10:
				shoot()

func _on_shootingCooldown_timeout():
	if shooted == true:
		shooted = false
