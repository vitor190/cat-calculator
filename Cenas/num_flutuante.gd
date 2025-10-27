extends Area2D

@export var valor: int
@onready var label = $Label
@onready var anim = $AnimationPlayer
@onready var som_coleta = $som_coleta

func _ready():
	label.text = str(valor)
	anim.play("flutua")  

func _on_body_entered(body):
	if body.name == "player":
		print("💡 Número coletado pelo player!")
		body.coletar_numero(valor)
		som_coleta.play()
		await som_coleta.finished  
		queue_free()
