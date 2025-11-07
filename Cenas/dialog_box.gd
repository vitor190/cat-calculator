extends MarginContainer

@onready var text_label: Label = $label_margin/text_label
@onready var letter_timer_display: Timer = $letter_timer_display

const MAX_WIDTH := 180  # ajuste menor pra caber o texto dentro da box

var text := ""
var letter_index := 0

var letter_display_timer := 0.07
var space_display_timer := 0.05
var punctuation_display_timer := 0.15

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = ""
	letter_index = 0
	
	# Garante quebra de linha dentro da caixa
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	text_label.custom_minimum_size.x = MAX_WIDTH
	
	display_letter()


func display_letter():
	if letter_index >= text.length():
		text_display_finished.emit()
		return
	
	text_label.text += text[letter_index]
	letter_index += 1
	
	if letter_index >= text.length():
		text_display_finished.emit()
		return
	
	match text[letter_index]:
		"!", "?", ",", ".":
			letter_timer_display.start(punctuation_display_timer)
		" ":
			letter_timer_display.start(space_display_timer)
		_:
			letter_timer_display.start(letter_display_timer)


func _on_letter_timer_display_timeout():
	display_letter()
