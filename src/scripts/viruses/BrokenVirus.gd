extends Area2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 600
var hasJustSpawned = false

func _ready():
	randomize()
	position.x = [-15,1300][randi() % 2]
	position.y = [-15,750][randi() % 2]
	$hasJustSpawned.start()
	hasJustSpawned = true
	
	z_index = 4
	z_as_relative = false
	
	var dir = (get_parent().get_node("player").global_position - global_position).normalized()
	global_rotation = dir.angle() + PI / 2.0
	direction = dir

func _process(delta):
	translate(direction*speed*delta)
	
func _on_hasJustSpawned_timeout():
	hasJustSpawned = false
	
func _physics_process(_delta):
	if !hasJustSpawned:
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()
