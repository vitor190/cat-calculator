extends Node

@onready var portao = $"../portao"
@onready var portao2 = $"../portao2"
@onready var player = $"../player"

@onready var ui_baixo = $"../UI_Baixo"
@onready var ui_cima = $"../UI_Cima"

@onready var som_acerto = $"../UI_Cima/SomAcerto"
@onready var som_erro = $"../UI_Cima/SomErro"
@onready var som_fase_concluida = $"../UI_Cima/SomFaseConcluida"

var a: int
var b: int
var resultado: int
var resposta_correta: int
var ui_atual
var botoes = []
var label_equacao

var fase_baixo_concluida := false

func _ready():
	randomize()
	if player:
	
		player.connect("todos_numeros_coletados", Callable(self, "_verificar_quantidade_numeros"))

func _verificar_quantidade_numeros():
	var qtd = player.numeros_coletados.size()
	print("📊 Números coletados:", qtd)

	
	if qtd == 2 and not fase_baixo_concluida:
		_mostrar_equacao(ui_baixo, 2)

	elif qtd == 3 and fase_baixo_concluida:
		ui_baixo.visible = false
		_mostrar_equacao(ui_cima, 3)

func _mostrar_equacao(ui, qtd):
	print("🧮 Gerando equação de subtração para:", ui.name)

	ui.visible = true
	ui_atual = ui

	if qtd == 2:
		botoes = [ui.get_node("Balao1"), ui.get_node("Balao2")]
	elif qtd == 3:
		botoes = [ui.get_node("Balao1"), ui.get_node("Balao2"), ui.get_node("Balao3")]

	label_equacao = ui.get_node("Equacao")
	label_equacao.visible = true

	for btn in botoes:
		btn.visible = true

	var numeros = player.numeros_coletados.duplicate()
	numeros.shuffle()

	if numeros.size() < 2:
		push_error("Poucos números coletados para criar a equação!")
		return

	a = numeros[0]
	b = numeros[1]
	resultado = a - b
	resposta_correta = b

	label_equacao.text = str(a) + " - ☐ = " + str(resultado)

	var respostas = player.numeros_coletados.duplicate()
	respostas.shuffle()

	for i in range(botoes.size()):
		if i < respostas.size():
			botoes[i].text = str(respostas[i])
		else:
			botoes[i].text = ""

		if botoes[i].is_connected("pressed", Callable(self, "_verificar_resposta")):
			botoes[i].disconnect("pressed", Callable(self, "_verificar_resposta"))
		botoes[i].connect("pressed", Callable(self, "_verificar_resposta").bind(int(botoes[i].text)))


func _verificar_resposta(valor: int):
	if valor == resposta_correta:
		if som_acerto:
			som_acerto.play()

		label_equacao.text = "✅ Correto! " + str(a) + " - " + str(valor) + " = " + str(resultado)

		for btn in botoes:
			btn.visible = false

		await get_tree().create_timer(0.4).timeout

		if ui_atual == ui_baixo:
			fase_baixo_concluida = true
			if portao2:
				portao2.abrir_portao()

		elif ui_atual == ui_cima:
			if portao:
				portao.abrir_portao()
			if som_fase_concluida:
				som_fase_concluida.play()

	else:
		if som_erro:
			som_erro.play()
		label_equacao.text = "❌ Errado! Tente novamente."
		
