extends Control

var instanciatedGuns = []
var isSubAGun = false
var isSubAGunOnce = false
var isSubAGunSelected = 0

var removeGun = false

onready var gunList = $BigAssWrapper/gunSelectionArea/GunList
onready var goBackButton = $BigAssWrapper/gunSelectionArea/centralizer/buttons/GoBack
onready var equipGunButton = $BigAssWrapper/gunSelectionArea/centralizer/buttons/EquipGun
onready var previewSlot1 = $BigAssWrapper/gunSelectionArea/centralizer/buttons/EquippedGunsPreview/slot1
onready var previewSlot2 = $BigAssWrapper/gunSelectionArea/centralizer/buttons/EquippedGunsPreview/slot2

onready var gunID = $BigAssWrapper/gunInfoArea/GunID
onready var gunPreviewSprite = $BigAssWrapper/gunInfoArea/previewSprite
onready var gunNameLabel = $BigAssWrapper/gunInfoArea/GunName
onready var gunDescLabel = $BigAssWrapper/gunInfoArea/ScrollContainer/GunDesc

func _ready():
	for i in GameManager.guns.size():
		instanciatedGuns.push_back(GameManager.guns[i].instance())
		
		gunList.add_item("")
		if !instanciatedGuns[i].previewSprite == null:
			gunList.set_item_icon(i, instanciatedGuns[i].previewSprite)
		else:
			gunList.set_item_icon(i, instanciatedGuns[i].gunNotFoundSprite)
		gunList.set_item_text(i, "")

func _process(delta):
	if isSubAGun == true and !isSubAGunOnce:
		equipGunButton.disabled = true
		goBackButton.disabled = true
		for i in GameManager.guns.size():
			gunList.set_item_disabled(i, true)
		isSubAGunOnce = true
		
	if !isSubAGun:
		equipGunButton.disabled = false
		goBackButton.disabled = false
		for i in GameManager.guns.size():
			gunList.set_item_disabled(i, false)
		
	if isSubAGunSelected == 0 and isSubAGun == true:
		previewSlot1.get_node("subCursor").visible = true
		previewSlot2.get_node("subCursor").visible = false
	if isSubAGunSelected == 1 and isSubAGun == true:
		previewSlot1.get_node("subCursor").visible = false
		previewSlot2.get_node("subCursor").visible = true
	elif isSubAGun == false:
		previewSlot1.get_node("subCursor").visible = false
		previewSlot2.get_node("subCursor").visible = false
	
	for i in GameManager.guns.size():
		if !GameManager.equippedGuns[0] == null:
			if GameManager.equippedGuns[0] == GameManager.guns[i]:
				previewSlot1.get_node("sprite").texture = instanciatedGuns[i].previewSprite
		else:
			previewSlot1.get_node("sprite").texture = null
				
		if !GameManager.equippedGuns[1] == null:
			if GameManager.equippedGuns[1] == GameManager.guns[i]:
				previewSlot2.get_node("sprite").texture = instanciatedGuns[i].previewSprite
		else:
			previewSlot2.get_node("sprite").texture = null
					
	if !gunList.get_selected_items().empty():
		if !isSubAGun:
			if GameManager.equippedGuns[0] == GameManager.guns[gunList.get_selected_items()[0]] or GameManager.equippedGuns[1] == GameManager.guns[gunList.get_selected_items()[0]]:
				equipGunButton.visible = true
				equipGunButton.disabled = false
				equipGunButton.text = "GUNDEX_EQUIPGUN_BUTTON_REMOVE"
				removeGun = true
			else:
				equipGunButton.visible = true
				equipGunButton.disabled = false
				equipGunButton.text = "GUNDEX_EQUIPGUN_BUTTON_EQUIP"
				removeGun = false
			if GameManager.equippedGuns[0] == GameManager.guns[gunList.get_selected_items()[0]] and GameManager.equippedGuns[1] == null or GameManager.equippedGuns[1] == GameManager.guns[gunList.get_selected_items()[0]] and GameManager.equippedGuns[0] == null:
				equipGunButton.visible = true
				equipGunButton.disabled = true
				equipGunButton.text = "GUNDEX_EQUIPGUN_BUTTON_EQUIPPED"
	
func _on_GunList_item_selected(index):
	if !isSubAGun:
		gunPreviewSprite.texture = instanciatedGuns[index].previewSprite
		gunNameLabel.text = instanciatedGuns[index].gunName
		gunDescLabel.text = instanciatedGuns[index].gunDesc
		if index <= 9:
			gunID.text = ("#00%d" % index)
		elif index >= 10:
			gunID.text = ("#0%d" % index)
		elif index >= 100:
			gunID.text = ("#%d" % index)
			
	previewSlot1.get_node("subCursor").get_node("gunToSub").texture = instanciatedGuns[gunList.get_selected_items()[0]].previewSprite
	previewSlot2.get_node("subCursor").get_node("gunToSub").texture = instanciatedGuns[gunList.get_selected_items()[0]].previewSprite
			
func _input(event):
	if isSubAGun == true:
		if event.is_action_pressed("ui_selectWeapon0"):
			isSubAGunSelected = 0
		if event.is_action_pressed("ui_selectWeapon1"):
			isSubAGunSelected = 1
		if event.is_action_pressed("ui_accept"):
			if !gunList.get_selected_items().empty():
				GameManager.equippedGuns[isSubAGunSelected] = GameManager.guns[gunList.get_selected_items()[0]]
			isSubAGunOnce = false
			$equippingGunSound.play()
			GameManager.save_equippedGuns(true)
			isSubAGun = false
		if event.is_action_pressed("ui_cancel"):
			isSubAGunOnce = false
			isSubAGun = false

func _on_GoBack_pressed():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_EquipGun_pressed():
	if !gunList.get_selected_items().empty():
		if removeGun == true:
			if GameManager.equippedGuns[0] == GameManager.guns[gunList.get_selected_items()[0]]:
				GameManager.equippedGuns[0] = null
				GameManager.save_equippedGuns(true)
			if GameManager.equippedGuns[1] == GameManager.guns[gunList.get_selected_items()[0]]:
				GameManager.equippedGuns[1] = null
				GameManager.save_equippedGuns(true)
		else:
			if !GameManager.equippedGuns[0] == null and !GameManager.equippedGuns[1] == null:
				isSubAGun = true
			if !GameManager.equippedGuns[0] == null and GameManager.equippedGuns[1] == null:
				GameManager.equippedGuns[1] = GameManager.guns[gunList.get_selected_items()[0]]
				$equippingGunSound.play()
				GameManager.save_equippedGuns(true)
			if !GameManager.equippedGuns[1] == null and GameManager.equippedGuns[0] == null:
				GameManager.equippedGuns[0] = GameManager.guns[gunList.get_selected_items()[0]]
				$equippingGunSound.play()
				GameManager.save_equippedGuns(true)
			if GameManager.equippedGuns[1] == null and GameManager.equippedGuns[0] == null:
				GameManager.equippedGuns[0] = GameManager.guns[gunList.get_selected_items()[0]]
				$equippingGunSound.play()
				GameManager.save_equippedGuns(true)
