extends KinematicBody2D 

const VEL_MAXIMA = 500 
var speed = 300
var move = Vector2()
var hp = 10
var maxhp = 10

func _process(delta): 
	var rotacao = move.x * 0.03 
	$col.rotation_degrees = lerp($col.rotation_degrees, rotacao, 0.03)
	
	var prev_move = move
	move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	move = move.normalized() * speed
	move = move_and_slide(lerp(prev_move, move, 0.1))
