extends KinematicBody2D

var direction : Vector2 = Vector2.LEFT
var velocity = 64
var health = 100
var vulnerable = false

func _ready():
	position.x = 1760
	position.y = 360
	
	z_index = 4
	z_as_relative = false

func _process(_delta):
	translate(direction*velocity*_delta)
	
	if health <= 0:
		vulnerable = false
		direction = Vector2.DOWN
		velocity = 500
		health = 0
		$ambient.stop()
	
func _physics_process(_delta):
	if position.x <= 1000:
		vulnerable = true
		velocity = 0

func _on_Area2D_area_entered(area):
	if area.is_in_group("projectile"):
		if vulnerable == true:
			if get_parent().get_node("player").slotSelected == 0:
				health -= get_parent().get_node("player").gunInstance.damage
			if get_parent().get_node("player").slotSelected == 1:
				health -= get_parent().get_node("player").gun2Instance.damage
			$damage.play("damage")
			$damageS.play()
