extends Area2D
class_name Tiro

var speed

func _ready():
    position = $"../player/gun/pos".global_position

func _process(delta):
    position += Vector2(speed * delta, 0)

func _on_Tiro_body_entered(body):
    if body.is_in_group("barrier"):
        queue_free()
