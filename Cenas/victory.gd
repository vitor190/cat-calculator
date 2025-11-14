
extends Control

@onready var musica_youwin = $AudioStreamPlayer2D

func _ready() -> void:
	musica_youwin.play()
	
func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/title_screen.tscn")
	
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
