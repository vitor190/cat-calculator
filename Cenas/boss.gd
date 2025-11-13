extends Node2D

@export var max_health: int = 100
var current_health: int = max_health

func _ready():
	$health_bar_boss.value = current_health
	$health_bar_boss.max_value = max_health

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	update_health_bar()
	if current_health <= 0:
		die()

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	update_health_bar()

func update_health_bar():
	# Atualiza a barra diretamente
	$health_bar_boss.value = current_health

func die():
	queue_free()  # Remove o boss da cena
