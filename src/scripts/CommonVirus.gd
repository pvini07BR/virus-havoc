extends Area2D

func _on_CommonVirus_area_entered(area: Area2D):
    if area.is_in_group("tiro"):
        print("colidiu")
