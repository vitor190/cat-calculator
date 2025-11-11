extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	
"Parabéns por chegar à fase final...",
"O grande desafio te espera: enfrente o Guardião dos Números!",
"Resolva as equações finais e prove que é digno da vitória suprema...",
]

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		
		# Interação com tecla "interact"
		if event.is_action_pressed("interact") and not DialogManager.is_message_active:
			texture.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture.hide()
