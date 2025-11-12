extends Node2D

@onready var musica_fase5 = $musica_fase5
@onready var player: Player = $player

func _ready() -> void:
	player.fase_atual = 1
	musica_fase5.play()
