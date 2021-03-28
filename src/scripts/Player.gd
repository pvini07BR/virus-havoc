extends KinematicBody2D 

const TIRO = preload("res://scenes/Tiro_padrão.tscn")
const VEL_MAXIMA = 500 
var speed = 400
var move = Vector2()
var hp = 10
var maxhp = 10
var tempo = false

func _process(_delta): 
    var rotacao = move.x * 0.02
    $col.rotation_degrees = lerp($col.rotation_degrees, rotacao, 1)
    
    var prev_move = move
    move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    
    move = move.normalized() * speed
    move = move_and_slide(lerp(prev_move, move, 0.02))

func _input(Event):
    if Event.is_action_pressed("ui_accept") and !tempo:
        get_parent().add_child(TIRO.instance())
        $Reload.start()
        tempo = true

func _on_Reload_timeout() -> void:
    tempo = false
