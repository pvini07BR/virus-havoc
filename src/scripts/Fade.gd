extends Node2D

var path

func _on_anim_animation_finished(anim_name):
	if anim_name == "fadeIn":
		$layer.offset.x = -1280
		$layer.offset.y = -720
	if anim_name == "fadeOut":
		GameManager.goto_scene(path)
		path = null

func _on_anim_animation_started(anim_name):
	if anim_name == "fadeOut":
		$layer.offset.x = 0
		$layer.offset.y = 0
