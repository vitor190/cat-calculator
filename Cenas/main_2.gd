extends Node2D

@onready var musica_fase2 = $musica_fase2
@onready var player = $player

func _ready() -> void:
	player.fase_atual = 2
	musica_fase2.play()
