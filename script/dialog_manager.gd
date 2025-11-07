extends Node

@onready var dialog_box_scene = preload("res://Cenas/dialog_box.tscn")

var message_lines: Array[String] = []
var current_line: int = 0

var dialog_box
var dialog_box_position := Vector2.ZERO

var is_message_active := false
var can_advance_message := false

# Ajuste da altura da caixa de diálogo
const DIALOG_OFFSET := Vector2(0, -65)

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
	
	message_lines = lines
	dialog_box_position = position
	current_line = 0
	_show_text()
	is_message_active = true


func _show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	
	# Adiciona na cena atual (segue câmera, camada, etc.)
	get_tree().current_scene.add_child(dialog_box)
	
	# Posição da caixa — um pouco acima da placa
	dialog_box.global_position = dialog_box_position + DIALOG_OFFSET
	
	dialog_box.display_text(message_lines[current_line])
	can_advance_message = false


func _on_all_text_displayed():
	can_advance_message = true


func _unhandled_input(event):
	if event.is_action_pressed("advance_message") and is_message_active and can_advance_message:
		dialog_box.queue_free()
		current_line += 1
		
		if current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			return
		
		_show_text()
