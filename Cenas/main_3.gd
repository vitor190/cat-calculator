extends Node2D

@onready var musica_fase3 = $musica_fase3

func _ready() -> void:
	musica_fase3.play()
