extends Node2D

@export var dialog_text: Array[String] = [
	"Olá viajante!",
	"Esta é uma placa de teste.",
	"Boa sorte na sua jornada!"
]

@onready var area = $Area2D
@onready var symbol = $InteractionSymbol

var player_near = false

func _ready():
	symbol.visible = false
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("Entrou em colisão com:", body.name)
	if body.name == "Player":
		player_near = true
		symbol.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		symbol.visible = false

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		var dialog_manager = get_tree().get_root().get_node_or_null("DialogManager")
		if dialog_manager:
			dialog_manager.start_message(dialog_text, global_position + Vector2(0, -80))
		else:
			print("⚠️ DialogManager não encontrado!")
