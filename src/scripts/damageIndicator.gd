extends Position2D

onready var label = get_node("Label")
onready var labelOutline = get_node("Label2")
onready var tween = get_node("Tween")
var amount : float = 0
var type = 0

var velocity = Vector2(0,0)

func _ready():
	z_index = 6
	z_as_relative = false
	
	match type:
		0:
			label.set("custom_colors/font_color",Color("ff0000"))
			label.set_text(str(amount))
			labelOutline.set_text(str(amount))
		1:
			label.set("custom_colors/font_color",Color("00a002"))
			label.text = ("+%d" % amount)
			labelOutline.text = ("+%d" % amount)
		2:
			label.set("custom_colors/font_color",Color("ff0000"))
			label.text = ("-%d" % amount)
			labelOutline.text = ("-%d" % amount)
	
	randomize()
	var side_movement = randi() % 80 - 40
	velocity = Vector2(side_movement, 50)
	
	tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(delta):
	position -= velocity * delta
