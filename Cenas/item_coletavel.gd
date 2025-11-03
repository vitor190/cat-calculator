extends Area2D

signal coletado  # ✅ sinal criado

@onready var som_coleta = $som_coleta

func _on_body_entered(body):
	if body.name == "player":
		print("💡 item coletado!")
		som_coleta.play()
		await som_coleta.finished
		emit_signal("coletado")  # ✅ emite o sinal
		queue_free()
