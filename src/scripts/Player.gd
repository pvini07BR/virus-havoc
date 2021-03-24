extends KinematicBody2D # O código escrito aqui será linkado ao nó, que também tem uns parâmetros pré definidos.

# Início do código, local para declarar variáveis e constantes.

const VEL_MAXIMA = 500 
var speed = 300
var move = Vector2() # Define a posição do jogador num campo de x e y, necessário pra movimento.

func _ready() -> void: # Essa função executa quando a cena do player começar
    pass # Simplesmente como não tem código, podemos pular.

func _process(delta): # Essa função executa coisas dentro a todo frame. O argumento "delta" é a framerate/velocidade do jogo.
    var rotacao = move.x * 0.1 # Ele pega o move.x e muliplica por 0.2
    $col.rotation_degrees = lerp($col.rotation_degrees, rotacao, 0.5) # Isso fará uma interpolação que fará o nó girar de acordo com a var rotação.
    
    var prev_move = move # Essa variável pega o movimento anterior do movimento atual.
    move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    
    move = move.normalized() * speed
    # Aí essa equação é normalizada pra não se mover rápido em diagonal e multiplicada por speed.
    move = move_and_slide(lerp(prev_move, move, 0.2))
    # Move_and_slide é uma função do KinematicBody2D pra detectar colisões e se mover, e rodar no framerate correto do game.
    #O lerp é uma interpolação com o valor inicial, final e o peso. Nesse caso, peguei o prev_move para definir o inicio, move pra definir o fim e 0.2 como peso.
