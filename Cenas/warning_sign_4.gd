extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	
	"Parabéns por completar a fase 3...",
	"Sua missão nessa fase é coletar todos os números espalhados pelo cenário...",
	"Resolver a equação de multiplicação, e assim, concluir o desafio...",
]

func _unhandled_input(event):
	# Detecta se o player está sobre a área da placa
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		
		# Interação com tecla "interact"
		if event.is_action_pressed("interact") and not DialogManager.is_message_active:
			texture.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture.hide()
