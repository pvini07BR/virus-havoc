extends Bullet
		
func _on_diagonalBullets_area_entered(area):
	print("area collided")
	if area.is_in_group("virus"):
		queue_free()
