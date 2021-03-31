extends Node2D

const TIRO = preload("res://scenes/Tiro_padrão.tscn")
var tempo = false
#var gunsEquiped = [0,0]

func _ready() -> void:
	pass

func _input(Event):
	if Event.is_action_pressed("ui_accept") and !tempo:
		get_parent().get_parent().add_child(TIRO.instance())
		$Timer.start()
		tempo = true

func _on_Timer_timeout() -> void:
	tempo = false
