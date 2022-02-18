extends Virus

var randomX
var randomY
var paper
var paperExists = false
var dir
var alcanceY
var alcanceX
var playerYDiffer
var playerXDiffer

func _init():
	rng.randomize()
	randomX = rng.randf_range(640, 960)
	randomY = rng.randf_range(50, 666)

func _ready():
	$movemente.interpolate_property(self, "position", Vector2(1310, randomY), Vector2(randomX, randomY), rng.randf_range(1,4))
	$movemente.start()
	
func _process(delta):
	var velocity = 100
	
	playerXDiffer = get_parent().get_node("player").global_position.x - global_position.x
	playerYDiffer = get_parent().get_node("player").global_position.y - global_position.y
	
	var playerYDifference = abs(playerYDiffer)
	var timeOfTravelY = sqrt(2 * playerYDifference / gravity)
	alcanceY = velocity * timeOfTravelY
	
	var playerXDifference = abs(playerXDiffer)
	var timeOfTravelX = sqrt(2 * playerXDifference / gravity)
	alcanceX = velocity * timeOfTravelX
	
func _on_movemente_tween_all_completed():
	shoot()

func _on_shootingTimer_timeout():
	if !paper == null and paperExists == true:
		if playerXDiffer > 0:
			paper.velocity.x = alcanceX
		elif playerXDiffer < 0:
			paper.velocity.x = -alcanceX
			
		if playerYDiffer > 0:
			paper.velocity.y = 0
		elif playerYDiffer < 0:
			paper.velocity.y = -alcanceY
		paper.shoot()
		$attackAnim.play("attack")
		paper = null
		paperExists = false
		shoot()
		
func shoot():
	paper = projectile.instance()
	paper.z_index = 1
	add_child(paper)
	$shootingTimer.start()
	paperExists = true
