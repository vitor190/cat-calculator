extends Node2D

@onready var musica_fase4 = $musica_fase4
@onready var player: Player = $player


func _ready() -> void:
	player.fase_atual = 2
	musica_fase4.play()
