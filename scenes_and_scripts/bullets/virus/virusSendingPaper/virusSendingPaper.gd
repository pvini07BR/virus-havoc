extends VirusBullet

var isShooted = false
var isReady = false
var dead = false

var velocity = Vector2(0, 0)

func _ready():
	set_as_toplevel(false)

func _physics_process(delta):
	if isReady == true and isShooted == true:
		velocity.y += gravity * delta
		global_position.x += velocity.x * delta
		global_position.y += velocity.y * delta
		
		
		if self.position.x <= 0:
			queue_free()
		if self.position.x >= 1280:
			queue_free()
		if self.position.y <= 0:
			queue_free()
		if self.position.y >= 720:
			queue_free()
			
	if get_parent().health <= 0 and !dead:
		$anim.play("fileDeleting")
		isReady = false
		isShooted = false
		remove_from_group("virusBullet")
		dead = true
		
		
func shoot():
	if !isShooted:
		set_as_toplevel(true)
		global_position = get_parent().global_position
		isShooted = true

func _on_virusSendingPaper_area_entered(area):
	if area.is_in_group("player"):
		if isShooted == true and isReady == true:
			queue_free()

func _on_anim_animation_finished(anim_name):
	if anim_name == "spawning":
		isReady = true
		get_parent().vulnerable = true
		get_parent().get_node("shootingTimer").start()
	elif anim_name == "fileDeleting":
		queue_free()
