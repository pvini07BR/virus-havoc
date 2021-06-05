extends Area2D

var direction
var finishOnce

func _ready():
	randomize()
	direction = [0,1][randi() % 2]
	
	$duration.wait_time = get_parent().get_node("beamingTimer").wait_time
	
	z_index = 5
	z_as_relative = false
	
	$appearTween.interpolate_property($ColorRect, "rect_scale", Vector2(1, 0), Vector2(1,1), 1)
	$disappearTween.interpolate_property($ColorRect, "rect_scale", Vector2(1,1), Vector2(1,0), 1)
	$disappearTween2.interpolate_property($ambient, "pitch_scale", 1, 0, 1)
	$disappearTween3.interpolate_property($ambient, "volume_db", -10, -80, 1)
	$appearTween.start()
	
	var dir = (get_parent().get_parent().get_node("player").global_position - global_position).normalized()
	
	if direction == 0:
		$aimTween.interpolate_property(self, "global_rotation", dir.angle() + PI / 1.3, dir.angle() + PI / 4.0, $duration.wait_time)
	if direction == 1:
		$aimTween.interpolate_property(self, "global_rotation", dir.angle() + PI / 4.0, dir.angle() + PI / 1.3, $duration.wait_time)
		
	$aimTween.start()

func _process(_delta):
	if get_parent().get_parent().stageFinished == true and !finishOnce:
		$disappearTween.interpolate_property($ColorRect, "rect_scale", Vector2(1,1), Vector2(1,0), 1)
		$disappearTween2.interpolate_property($ambient, "pitch_scale", 1, 0, 1)
		$disappearTween3.interpolate_property($ambient, "volume_db", -10, -80, 1)
		$disappearTween.start()
		$disappearTween2.start()
		$disappearTween3.start()
		finishOnce = true

func _on_disappearTween_tween_all_completed():
	queue_free()

func _on_duration_timeout():
	$disappearTween.start()
	$disappearTween2.start()
	$disappearTween3.start()

func _on_appearTween_tween_all_completed():
	self.add_to_group('virusBeam')

func _on_disappearTween_tween_started(object, key):
	self.remove_from_group('virusBeam')
