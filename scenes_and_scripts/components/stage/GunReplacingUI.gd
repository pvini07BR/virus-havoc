extends CanvasLayer

var newGun

onready var slot1 = $cent/vert/horiz/slot1
onready var slot2 = $cent/vert/horiz/slot2
onready var discardButton = $cent/vert/centralizer/discardButton

var currentSelected = clamp(0, 0, 1)
var instanciatedNewGun

func _ready():
	if !GameManager.platform == GameManager.PLATFORMS.MOBILE:
		$cent/vert/mobile.queue_free()
	
	instanciatedNewGun = newGun.instance()
	
	if !newGun == null:
		slot1.get_node("selector/newGunSprite").texture = instanciatedNewGun.previewSprite
		slot2.get_node("selector/newGunSprite").texture = instanciatedNewGun.previewSprite
	
	GameManager.musicStream.pause_mode = Node.PAUSE_MODE_PROCESS
	GameManager.itsAlreadyPaused = true
	get_tree().paused = true
	if !GameManager.equippedGuns[0] == null:
		slot1.get_node("gunSprite").texture = GameManager.equippedGuns[0].instance().previewSprite
	if !GameManager.equippedGuns[1] == null:
		slot2.get_node("gunSprite").texture = GameManager.equippedGuns[1].instance().previewSprite
		
func _process(delta):
	slot1.get_node("selector").visible = false
	slot2.get_node("selector").visible = false
	
	match(currentSelected):
		0:
			slot1.get_node("selector").visible = true
		1:
			slot2.get_node("selector").visible = true
	
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_selectWeapon0"):
		if currentSelected > 0:
			currentSelected -= 1
		currentSelected = clamp(currentSelected, 0, 1)
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_selectWeapon1"):
		if currentSelected < 1:
			currentSelected += 1
		currentSelected = clamp(currentSelected, 0, 1)
		
	if Input.is_action_just_pressed("ui_accept"):
		GameManager.currentScene.replaceGun(currentSelected, newGun)
		
		GameManager.itsAlreadyPaused = false
		get_tree().paused = false
		GameManager.musicStream.pause_mode = Node.PAUSE_MODE_STOP
		queue_free()

func _on_discardButton_pressed():
	GameManager.itsAlreadyPaused = false
	get_tree().paused = false
	GameManager.musicStream.pause_mode = Node.PAUSE_MODE_STOP
	queue_free()
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			GameManager.musicStream.pause_mode = Node.PAUSE_MODE_STOP
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			GameManager.musicStream.pause_mode = Node.PAUSE_MODE_PROCESS

func _on_Button_pressed():
	var a = InputEventKey.new()
	a.scancode = KEY_ENTER
	a.pressed = true
	Input.parse_input_event(a)
