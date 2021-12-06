extends Gun

var shooted = false
var shootingState = 0
var bulletsSpawned = 0
var pressed = false

var bullets : Array

func _ready():
	$rainbowEffect.interpolate_property($sprite.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.interpolate_property($ray.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.interpolate_property($raytracing.get_material(), "shader_param/Shift_Hue", 0, 1, 2, Tween.TRANS_LINEAR)
	$rainbowEffect.start()

func _process(_delta):
	if shootingState == 2 and !shooted or !active and !shooted and pressed == true or !GameManager.currentScene.inputWorking and !shooted and pressed == true:
		for i in bullets:
			i.moving = true
		bullets.clear()
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
		
	if GameManager.currentScene.inputWorking == true:
		if active == true:
			if Input.is_action_just_pressed("ui_accept"):
				if !pressed:
					if !shooted:
						shootingState += 1
			if !shooted:
				if Input.is_action_just_released("ui_accept"):
					if pressed == true:
						shootingState += 1
						$release.play()
						pressed = false
		
func shoot():
	if !pressed:
		pressed = true
	if !shooted:
		bullets.append(projectile.instance())
		bullets[bulletsSpawned].damage = damage
		add_child(bullets[bulletsSpawned])
		bullets[bulletsSpawned].set_as_toplevel(true)
		bullets[bulletsSpawned].global_position.y = 640 - bulletsSpawned * 63
		bullets[bulletsSpawned].global_position.x = global_position.x + 300
		bulletsSpawned += 1

func _on_cooldown_timeout():
	if !shooted:
		if shootingState == 1:
			if !bulletsSpawned >= 10:
				shoot()

func _on_shootingCooldown_timeout():
	if shooted == true:
		shooted = false
