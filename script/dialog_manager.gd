extends Node

@onready var dialog_box_scene = preload("res://Cenas/dialog_box.tscn")  # certifica-se que é a cena, não um .gd
var message_lines: Array[String] = []
var current_line: int = 0

var dialog_box: Node = null
var dialog_box_position: Vector2 = Vector2.ZERO

var is_message_active: bool = false
var can_advance_message: bool = false

func start_message(lines: Array[String], posit: Vector2 = Vector2.ZERO) -> void:
	if is_message_active:
		return

	message_lines = lines
	current_line = 0  # reinicia para a primeira frase
	dialog_box_position = posit
	is_message_active = true
	_show_text()

func _show_text() -> void:
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)  # ou adicione a um CanvasLayer se for UI
	dialog_box.global_position = dialog_box_position
	dialog_box.call("display_text", message_lines[current_line])
	can_advance_message = false

func _on_all_text_displayed() -> void:
	can_advance_message = true

func _unhandled_input(event) -> void:
	if is_message_active and can_advance_message and event.is_action_pressed("advance_message"):
		# fecha a caixa atual
		if dialog_box:
			dialog_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size():
			# fim das mensagens
			is_message_active = false
			current_line = 0
			dialog_box = null
		else:
			_show_text()
