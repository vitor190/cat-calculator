extends Node

@onready var portao = $"../portao"
@onready var ui = $"../UI"
@onready var musica_de_fundo = $"../musica_fase3"
@onready var som_acerto = ui.get_node("SomAcerto")
@onready var som_erro = ui.get_node("SomErro")
@onready var som_fase_concluida = ui.get_node("SomFaseConcluida")
@onready var label_equacao = ui.get_node("Equacao")
@onready var botoes = [
	ui.get_node("Balao1"),
	ui.get_node("Balao2"),
	ui.get_node("Balao3")
]
@onready var itens_container = $"../item_coletavel" 

var total_itens := 0
var coletados := 0
var resposta_correta := 0
var quiz_mostrado := false

func _ready():
	randomize()

	for child in itens_container.get_children():
		if child.has_node("item_coletavel"):
			var item = child.get_node("item_coletavel")
			total_itens += 1
			item.connect("coletado", Callable(self, "_on_item_coletado"))

	print("🐤 Total de itens coletáveis detectados:", total_itens)

	label_equacao.visible = false
	for btn in botoes:
		btn.visible = false

func _on_item_coletado():
	coletados += 1
	print("🦆 Coletado:", coletados, "/", total_itens)

	if coletados >= total_itens and not quiz_mostrado:
		quiz_mostrado = true
		await get_tree().create_timer(0.5).timeout
		_mostrar_quiz()

func _mostrar_quiz():
	print("📋 Mostrando quiz...")

	label_equacao.visible = true
	for btn in botoes:
		btn.visible = true

	label_equacao.text = "Quantos patos você coletou?"
	resposta_correta = total_itens

	var respostas = [resposta_correta]
	while respostas.size() < 3:
		var n = randi_range(1, total_itens + 5)
		if n != resposta_correta and n not in respostas:
			respostas.append(n)
	respostas.shuffle()

	for i in range(botoes.size()):
		var btn = botoes[i]
		btn.text = str(respostas[i])
		if btn.is_connected("pressed", Callable(self, "_verificar_resposta")):
			btn.disconnect("pressed", Callable(self, "_verificar_resposta"))
		btn.connect("pressed", Callable(self, "_verificar_resposta").bind(int(btn.text)))

func _verificar_resposta(valor: int):
	if valor == resposta_correta:
		print("✅ Correto! Você coletou", resposta_correta)
		som_acerto.play()
		label_equacao.text = "✅ Correto! Você coletou " + str(resposta_correta) + " patos!"

		for btn in botoes:
			btn.visible = false

		if portao and portao.has_method("abrir_portao"):
			portao.abrir_portao()
			await get_tree().create_timer(0.8).timeout

		musica_de_fundo.stop()
		som_fase_concluida.play()
	else:
		som_erro.play()
		label_equacao.text = "❌ Errado! Tente novamente."
