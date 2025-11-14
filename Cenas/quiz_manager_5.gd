extends Node

@onready var portao = $"../portao"
@onready var player = $"../player"
@onready var ui = $"../UI"
@onready var musica_de_fundo = $"../musica_fase5" # ajuste conforme sua cena
@onready var som_acerto = ui.get_node("SomAcerto")
@onready var som_erro = ui.get_node("SomErro")
@onready var som_fase_concluida = ui.get_node("SomFaseConcluida")
@onready var label_equacao = ui.get_node("Equacao")
@onready var botoes = [
	ui.get_node("Balao1"),
	ui.get_node("Balao2"),
	ui.get_node("Balao3")
]

var a: int
var b: int
var resultado: int
var resposta_correta: int


func _ready():
	randomize()
	if player:
		player.connect("todos_numeros_coletados", Callable(self, "_mostrar_equacao_divisao"))

	label_equacao.visible = false
	for btn in botoes:
		btn.visible = false


# ------------------------------------------------------------
# MOSTRA A EQUAÇÃO DE DIVISÃO (usando apenas números coletados)
# ------------------------------------------------------------
func _mostrar_equacao_divisao():
	print("🧮 Gerando equação de divisão com os números coletados...")

	label_equacao.visible = true
	for btn in botoes:
		btn.visible = true

	var numeros = player.numeros_coletados.duplicate()

	if numeros.size() < 2:
		push_error("Poucos números coletados para criar a equação!")
		return

	numeros.shuffle()
	a = numeros[0]
	b = numeros[1]

	# Garante que a seja o maior
	if a < b:
		var temp = a
		a = b
		b = temp

	# Evita divisão por zero
	if b == 0:
		b = 1

	# Se a divisão não for exata, ajusta para um múltiplo
	if a % b != 0:
		a = b * int(a / b + 1)

	# Calcula resultado exato
	resultado = int(a / b)
	resposta_correta = resultado

	label_equacao.text = "%d ÷ %d = ?" % [a, b]

	# Gera 3 opções (uma correta + duas erradas)
	var respostas = [resposta_correta]

	while respostas.size() < 3:
		var errada = resposta_correta + randi_range(-3, 3)
		if errada > 0 and errada not in respostas:
			respostas.append(errada)

	respostas.shuffle()

	for i in range(3):
		botoes[i].text = str(respostas[i])

		if botoes[i].is_connected("pressed", Callable(self, "_verificar_resposta")):
			botoes[i].disconnect("pressed", Callable(self, "_verificar_resposta"))
		botoes[i].connect("pressed", Callable(self, "_verificar_resposta").bind(int(botoes[i].text)))

func _verificar_resposta(valor: int):
	if valor == resposta_correta:
		som_acerto.play()
		label_equacao.text = "✅ Correto! %d ÷ %d = %d" % [a, b, resposta_correta]

		for btn in botoes:
			btn.visible = false

		if portao and portao.has_method("abrir_portao"):
			portao.abrir_portao()

	else:
		som_erro.play()
		label_equacao.text = "❌ Errado! Tente novamente."
