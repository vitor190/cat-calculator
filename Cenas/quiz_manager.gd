extends Node

@onready var player = $"../player"
@onready var ui = $"../UI"
@onready var label_equacao = ui.get_node("Equacao")
@onready var botoes = [
	ui.get_node("Balao1"),
	ui.get_node("Balao2"),
	ui.get_node("Balao3")
]

var a: int
var b: int
var soma: int
var resposta_correta: int

func _ready():
	randomize()
	if player:
		player.connect("todos_numeros_coletados", Callable(self, "_mostrar_equacao"))

func _mostrar_equacao():
	print("🧮 Gerando equação com números coletados...")

	label_equacao.visible = true
	for btn in botoes:
		btn.visible = true

	# Copia e embaralha os números coletados
	var numeros = player.numeros_coletados.duplicate()
	numeros.shuffle()

	if numeros.size() < 2:
		push_error("Poucos números coletados para criar a equação!")
		return

	# Escolhe dois números aleatórios do conjunto coletado
	a = numeros[0]
	b = numeros[1]
	soma = a + b
	resposta_correta = b

	# Mostra a equação no formato desejado
	label_equacao.text = str(a) + " + ☐ = " + str(soma)

	# 🔢 Define os textos dos botões exatamente com os números coletados
	for i in range(botoes.size()):
		if i < numeros.size():
			botoes[i].text = str(numeros[i])
		else:
			botoes[i].text = ""  # caso tenha menos de 3 números

		# Conecta o clique
		if botoes[i].is_connected("pressed", Callable(self, "_verificar_resposta")):
			botoes[i].disconnect("pressed", Callable(self, "_verificar_resposta"))
		botoes[i].connect("pressed", Callable(self, "_verificar_resposta").bind(int(botoes[i].text)))

func _verificar_resposta(valor: int):
	if valor == resposta_correta:
		label_equacao.text = "✅ Correto! " + str(a) + " + " + str(valor) + " = " + str(soma)
		for btn in botoes:
			btn.visible = false
	else:
		label_equacao.text = "❌ Errado! Tente novamente."
