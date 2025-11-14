extends Control

@onready var musica_game_over = $AudioStreamPlayer2D

func _ready() -> void:
	musica_game_over.play()
	
func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/main_5.tscn")
	
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
