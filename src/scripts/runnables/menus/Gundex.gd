extends Node2D

var instanciatedGuns = []
var isSubAGun = false
var isSubAGunOnce = false
var isSubAGunSelected = 0

var removeGun = false

func _ready():
	for i in GameManager.guns.size():
		instanciatedGuns.push_back(GameManager.guns.values()[i].instance())
		
		$GunList.add_item(GameManager.guns.keys()[i])
		if !instanciatedGuns[i].previewSprite == null:
			$GunList.set_item_icon(i, instanciatedGuns[i].previewSprite)
		else:
			$GunList.set_item_icon(i, instanciatedGuns[i].gunNotFoundSprite)
		$GunList.set_item_text(i, "")
		
	if GameManager.language == 0:
		$GoBack.text = "Voltar"
	if GameManager.language == 1:
		$GoBack.text = "Go back"

func _process(delta):
	if isSubAGun == true and !isSubAGunOnce:
		$EquipGun.disabled = true
		$GoBack.disabled = true
		for i in GameManager.guns.size():
			$GunList.set_item_disabled(i, true)
		$EquippedGunsPreview/subCursor.visible = true
		isSubAGunOnce = true
	if !isSubAGun:
		$EquipGun.disabled = false
		$GoBack.disabled = false
		for i in GameManager.guns.size():
			$GunList.set_item_disabled(i, false)
		$EquippedGunsPreview/subCursor.visible = false
		
	if isSubAGunSelected == 0:
		$EquippedGunsPreview/subCursor.position.x = $EquippedGunsPreview/slot1.rect_position.x
	if isSubAGunSelected == 1:
		$EquippedGunsPreview/subCursor.position.x = $EquippedGunsPreview/slot2.rect_position.x
	
	for i in GameManager.guns.size():
		if !GameManager.equippedGuns[0] == null:
			if GameManager.equippedGuns[0] == GameManager.guns.values()[i]:
				if !instanciatedGuns[i].previewSprite == null:
					$EquippedGunsPreview/slot1/sprite.texture = instanciatedGuns[i].previewSprite
				else:
					$EquippedGunsPreview/slot1/sprite.texture = instanciatedGuns[i].gunNotFoundSprite
		else:
			$EquippedGunsPreview/slot1/sprite.texture = null
				
		if !GameManager.equippedGuns[1] == null:
			if GameManager.equippedGuns[1] == GameManager.guns.values()[i]:
				if !instanciatedGuns[i].previewSprite == null:
					$EquippedGunsPreview/slot2/sprite.texture = instanciatedGuns[i].previewSprite
				else:
					$EquippedGunsPreview/slot2/sprite.texture = instanciatedGuns[i].gunNotFoundSprite
		else:
			$EquippedGunsPreview/slot2/sprite.texture = null
					
	if !$GunList.get_selected_items().empty():
		if !isSubAGun:
			if GameManager.equippedGuns[0] == GameManager.guns.values()[$GunList.get_selected_items()[0]] or GameManager.equippedGuns[1] == GameManager.guns.values()[$GunList.get_selected_items()[0]]:
				$EquipGun.visible = true
				$EquipGun.disabled = false
				$EquipGun.rect_position = Vector2(591, 646)
				if GameManager.language == 0:
					$EquipGun.text = "(Remover)"
				if GameManager.language == 1:
					$EquipGun.text = "(Remove)"
				removeGun = true
			else:
				$EquipGun.visible = true
				$EquipGun.disabled = false
				$EquipGun.rect_position = Vector2(591, 646)
				if GameManager.language == 0:
					$EquipGun.text = "Equipar"
				if GameManager.language == 1:
					$EquipGun.text = "Equip"
				removeGun = false
			if GameManager.equippedGuns[0] == GameManager.guns.values()[$GunList.get_selected_items()[0]] and GameManager.equippedGuns[1] == null or GameManager.equippedGuns[1] == GameManager.guns.values()[$GunList.get_selected_items()[0]] and GameManager.equippedGuns[0] == null:
				$EquipGun.visible = true
				$EquipGun.disabled = true
				$EquipGun.rect_position = Vector2(591, 646)
				if GameManager.language == 0:
					$EquipGun.text = "(Equipado)"
				if GameManager.language == 1:
					$EquipGun.text = "(Equipado)"
				
	$GunDesc.rect_position.y = $GunName.rect_position.y + $GunName.rect_size.y
	$GunDesc.rect_size.y = 720 - $GunDesc.rect_position.y
	$GunName.rect_size.y = 0
	
func _on_GunList_item_selected(index):
	if !isSubAGun:
		if !instanciatedGuns[index].previewSprite == null:
			$previewSprite.texture = instanciatedGuns[index].previewSprite
		if !instanciatedGuns[index].namePTBR == null or !instanciatedGuns[index].nameEng == null:
			if GameManager.language == 0:
				$GunName.text = instanciatedGuns[index].namePTBR
			if GameManager.language == 1:
				$GunName.text = instanciatedGuns[index].nameEng
		else:
			if GameManager.language == 0:
				$GunName.text = instanciatedGuns[index].nameNotFoundPTBR
			if GameManager.language == 1:
				$GunName.text = instanciatedGuns[index].nameNotFoundEng
		if !instanciatedGuns[index].descPTBR == null or !instanciatedGuns[index].descEng == null:
			if GameManager.language == 0:
				$GunDesc.text = instanciatedGuns[index].descPTBR
			if GameManager.language == 1:
				$GunDesc.text = instanciatedGuns[index].descEng
		else:
			if GameManager.language == 0:
				$GunDesc.text = instanciatedGuns[index].descNotFoundPTBR
			if GameManager.language == 1:
				$GunDesc.text = instanciatedGuns[index].descNotFoundEng
		if index <= 9:
			$GunID.text = ("#00%d" % index)
		elif index >= 10:
			$GunID.text = ("#0%d" % index)
		elif index >= 100:
			$GunID.text = ("#%d" % index)
			
func _input(event):
	if isSubAGun == true:
		if event.is_action_pressed("ui_selectWeapon0"):
			isSubAGunSelected = 0
		if event.is_action_pressed("ui_selectWeapon1"):
			isSubAGunSelected = 1
		if event.is_action_pressed("ui_accept"):
			if !$GunList.get_selected_items().empty():
				GameManager.equippedGuns[isSubAGunSelected] = GameManager.guns.values()[$GunList.get_selected_items()[0]]
			isSubAGunOnce = false
			GameManager.save_equippedGuns(true)
			isSubAGun = false

func _on_GoBack_pressed():
	GameManager.get_node("Fade").path = "res://scenes/runnables/menus/DebugMenu.tscn"
	GameManager.get_node("Fade/layer/anim").play("fadeOut")

func _on_EquipGun_pressed():
	if !$GunList.get_selected_items().empty():
		if removeGun == true:
			if GameManager.equippedGuns[0] == GameManager.guns.values()[$GunList.get_selected_items()[0]]:
				GameManager.equippedGuns[0] = null
				GameManager.save_equippedGuns(true)
			if GameManager.equippedGuns[1] == GameManager.guns.values()[$GunList.get_selected_items()[0]]:
				GameManager.equippedGuns[1] = null
				GameManager.save_equippedGuns(true)
		else:
			if !GameManager.equippedGuns[0] == null and !GameManager.equippedGuns[1] == null:
				isSubAGun = true
				$EquippedGunsPreview/subCursor/sprite.texture = instanciatedGuns[$GunList.get_selected_items()[0]].previewSprite
			if !GameManager.equippedGuns[0] == null and GameManager.equippedGuns[1] == null:
				GameManager.equippedGuns[1] = GameManager.guns.values()[$GunList.get_selected_items()[0]]
				GameManager.save_equippedGuns(true)
			if !GameManager.equippedGuns[1] == null and GameManager.equippedGuns[0] == null:
				GameManager.equippedGuns[0] = GameManager.guns.values()[$GunList.get_selected_items()[0]]
				GameManager.save_equippedGuns(true)
			if GameManager.equippedGuns[1] == null and GameManager.equippedGuns[0] == null:
				GameManager.equippedGuns[0] = GameManager.guns.values()[$GunList.get_selected_items()[0]]
				GameManager.save_equippedGuns(true)
