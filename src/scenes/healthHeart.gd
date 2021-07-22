extends Area2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 500
var moving = false

func _ready():
	z_index = 4
	z_as_relative = false

func _process(delta):
	if moving == true:
		translate(direction*speed*delta)
		if position.x <= 0:
			queue_free()

func _on_healthHeart_area_entered(area):
	if area.is_in_group("player"):
		moving = false
		$AnimationPlayer.play("heartGet")

func _on_effects_animation_finished(anim_name):
	if anim_name == "healthAppear":
		moving = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "heartGet":
		get_parent().get_node("player").gotHeart = false
		queue_free()
