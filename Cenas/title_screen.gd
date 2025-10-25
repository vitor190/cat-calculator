extends Control

@onready var musica_fundo = $MarginContainer/musica_de_fundo

	
func _ready() -> void:
	musica_fundo.play()
	

func _on_start_btn_pressed() -> void:
	musica_fundo.stop()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")


func _on_credits_btn_pressed() -> void:
	musica_fundo.stop()
	get_tree().change_scene_to_file("res://Cenas/credits_screen.tscn")
	


func _on_quit_btn_pressed() -> void:
	musica_fundo.stop()
	get_tree().quit()
	


	
