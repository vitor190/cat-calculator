extends Button
@onready var button: Button = $"."

func _ready():
	button.grab_focus()

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/title_screen.tscn")
