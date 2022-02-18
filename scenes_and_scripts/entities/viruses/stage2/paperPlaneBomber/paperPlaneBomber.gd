extends Virus

var bomb
var randomY
var direction
var hasLaunched = false

func _init():
	randomize()
	direction = [0,1][randi() % 2]

func _ready():
	rng.randomize()
	randomY = rng.randf_range(50, get_parent().get_node("player").position.y - 100)
	
	match direction:
		0:
			$Sprite.scale.x = 1
			$movement.interpolate_property(self, "position", Vector2(1300,randomY), Vector2(-50, randomY), 5)
		1:
			$Sprite.scale.x = -1
			$movement.interpolate_property(self, "position", Vector2(-50,randomY), Vector2(1300, randomY), 5)
	$movement.start()
	
	bomb = projectile.instance()
	bomb.position = $bombPos.position
	bomb.z_index = 0
	add_child(bomb)
	
	vulnerable = true
	
func _process(delta):
	if position.y < 50:
		position.y = 50

func _on_movement_tween_all_completed():
	queue_free()

func _on_playerDetector_area_entered(area):
	if area.is_in_group("player"):
		if !hasLaunched:
			randomize()
			bomb.damage = [1,2][randi() % 2]
			bomb.launch()
			if !shootingSound == null:
				SoundManager.playSound(shootingSound, -15, 1)
			hasLaunched = true
