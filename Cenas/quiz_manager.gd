extends Node



@onready var portao = $"../portao"
@onready var player = $"../player"
@onready var ui = $"../UI"
@onready var musica_de_fundo = $"../musica_fase1"
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
		
	var numeros = player.numeros_coletados.duplicate()
	numeros.shuffle()

	if numeros.size() < 2:
		push_error("Poucos números coletados para criar a equação!")
		return

	a = numeros[0]
	b = numeros[1]
	soma = a + b
	resposta_correta = b

	label_equacao.text = str(a) + " + ☐ = " + str(soma)

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
		som_acerto.play()
		label_equacao.text = "✅ Correto! " + str(a) + " + " + str(valor) + " = " + str(soma)
		
		for btn in botoes:
			btn.visible = false
		if portao:
			portao.abrir_portao()
			await get_tree().create_timer(0.8).timeout
		musica_de_fundo.stop()
		som_fase_concluida.play()
	else:
		som_erro.play()
		label_equacao.text = "❌ Errado! Tente novamente."
