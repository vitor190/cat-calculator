extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		print("🌊 O jogador caiu na água! Reiniciando a cena...")
		get_tree().reload_current_scene()
