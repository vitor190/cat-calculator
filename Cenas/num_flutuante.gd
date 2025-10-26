extends Area2D

@export var valor: int
@onready var label = $Label
@onready var anim = $AnimationPlayer

func _ready():
	label.text = str(valor)
	anim.play("flutua")  

func _on_body_entered(body):
	queue_free()
