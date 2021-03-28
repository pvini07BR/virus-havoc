extends Tiro

func _init():
    speed = 500

func _physics_process(_delta):
    if self.position.x > 1280:
        queue_free()
