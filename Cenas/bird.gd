extends AnimatedSprite2D

@export var speed = 40
@export var limite_direita = 2600
@export var limite_esquerda = -200
@export var amplitude = 10
@export var freq = 2.0

var tempo := 0.0

func _ready():
	flip_h = true  

func _process(delta):
	tempo += delta
	position.x += speed * delta
	position.y += sin(tempo * freq) * amplitude * delta

	if position.x > limite_direita:
		position.x = limite_esquerda
