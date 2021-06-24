extends Area2D

var isShooted = false
var isReady = false

var direction : Vector2
var speed = 300

func _physics_process(delta):
	if isReady == true and isShooted == true:
		translate(direction*speed*delta)
		
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()
		
func shoot():
	if !isShooted:
		set_as_toplevel(true)
		global_position = get_parent().global_position
		var dir = (get_tree().get_nodes_in_group("stage")[0].get_node("player").global_position - global_position).normalized()
		direction = dir
		isShooted = true

func _on_virusSendingPaper_area_entered(area):
	if area.is_in_group("player"):
		if isShooted == true and isReady == true:
			queue_free()

func _on_anim_animation_finished(anim_name):
	isReady = true
	get_parent().vulnerable = true
	get_parent().get_node("shootingTimer").start()
