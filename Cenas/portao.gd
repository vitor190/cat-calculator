extends Area2D

class_name Portao

@onready var anim = $AnimatedSprite2D
@onready var colisao = $CollisionShape2D

var aberto = false

func _ready():
	anim.play("portao")
	colisao.disabled = false
	connect("body_entered", Callable(self, "_quando_encostar"))

func _quando_encostar(body):
	if body.name == "player" and not aberto:
		body.position.x -= 10

func abrir_portao():
	if aberto:
		return
	aberto = true
	print("🔓 Portão abrindo...")
	anim.play("portao aberto")  
	await anim.animation_finished  
	colisao.disabled = true  
	print("✅ Portão aberto! Pode passar.")
