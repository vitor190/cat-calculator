extends Node

# --------------------------------------------------
# REFERÊNCIAS DA CENA
# --------------------------------------------------
@onready var portao = $"../portao"
@onready var player = $"../player"
@onready var boss = $"../boss"

@onready var hp_player = $"../player/Health_bar_player"
@onready var hp_boss = $"../boss/health_bar_boss"

@onready var ui_boss = $"../UI_boss"
@onready var victory_label = $"../UI_boss/VictoryLabel"

@onready var som_acerto = $"../UI_boss/UI2/SomAcerto"
@onready var som_erro = $"../UI_boss/UI2/SomErro"
@onready var som_fase_concluida = $"../UI_boss/UI2/SomFaseConcluida"


# --------------------------------------------------
# LISTA DE ANIMAÇÕES DE VIDA (PLAYER E BOSS)
# --------------------------------------------------
var anims_player := [
	"vida_cheia_player",  # índice 0
	"3_4_vida_player",    # índice 1
	"meia_vida_player",   # índice 2
	"quase_vida_player",  # índice 3
	"sem_vida_player"     # índice 4 (morto)
]

var anims_boss := [
	"vida_cheia_boss",
	"3_4_vida_boss",
	"meia_vida_boss",
	"quase_vida_boss",
	"sem_vida_boss"
]

var idx_vida_player := 0
var idx_vida_boss := 0

var uis = []
var ui_atual_index := 0

var equacao_label
var botoes
var resposta_correta
var a
var b


func _ready():
	randomize()

	# Esconder barras de vida até abrir a porta
	hp_player.visible = false
	hp_boss.visible = false

	# Conectar evento do portão
	if portao.has_signal("portao_aberto"):
		portao.connect("portao_aberto", Callable(self, "_iniciar_quiz"))
	else:
		print("❌ O portão não possui o sinal 'portao_aberto'!")

	# Registrar UIs e escondê-las
	for child in ui_boss.get_children():
		if child.name.begins_with("UI"):
			child.visible = false
			uis.append(child)

# --------------------------------------------------
# INÍCIO DO QUIZ APÓS O PORTÃO ABRIR
# --------------------------------------------------
func _iniciar_quiz():
	print("🎯 Portão abriu → Iniciando Boss Quiz!")

	# Resetar vidas (índice 0 = vida cheia)
	idx_vida_player = 0
	idx_vida_boss = 0

	# Atualiza animações
	_atualizar_vida_player()
	_atualizar_vida_boss()

	# Mostrar barras de vida
	hp_player.visible = true
	hp_boss.visible = true

	# Começar UI 1
	ui_atual_index = 0
	_iniciar_ui()

# --------------------------------------------------
# ATIVAR UI ATUAL
# --------------------------------------------------
func _iniciar_ui():
	if ui_atual_index >= uis.size():
		_boss_morre()
		return

	var ui = uis[ui_atual_index]
	ui.visible = true

	equacao_label = ui.get_node("Equacao")
	botoes = [
		ui.get_node("Balao1"),
		ui.get_node("Balao2"),
		ui.get_node("Balao3")
	]

	equacao_label.visible = true

	_gerar_equacao()
	_configurar_botoes()

# --------------------------------------------------
# GERAR EQUAÇÃO ALEATÓRIA
# --------------------------------------------------
func _gerar_equacao():
	a = randi_range(1, 10)
	b = randi_range(1, 10)

	var ops = ["+", "-", "×", "÷"]
	var op = ops.pick_random()

	match op:
		"+":
			resposta_correta = a + b
		"-":
			resposta_correta = a - b
		"×":
			resposta_correta = a * b
		"÷":
			b = [1,2,5,10].pick_random()
			a = b * randi_range(1, 10)
			resposta_correta = a / b

	equacao_label.text = "%d %s %d = ?" % [a, op, b]

	var respostas = [resposta_correta]

	while respostas.size() < 3:
		var err = resposta_correta + randi_range(-4, 4)
		if err > 0 and err not in respostas:
			respostas.append(err)

	respostas.shuffle()

	for i in range(3):
		botoes[i].text = str(respostas[i])

# --------------------------------------------------
# CONFIGURAR BOTÕES
# --------------------------------------------------
func _configurar_botoes():
	var callback = Callable(self, "_verificar_resposta")

	for botao in botoes:
		if botao.is_connected("pressed", callback):
			botao.disconnect("pressed", callback)

		botao.connect("pressed", callback.bind(int(botao.text)))
		botao.visible = true

# --------------------------------------------------
# VERIFICAR RESPOSTA
# --------------------------------------------------
func _verificar_resposta(valor):
	if valor == resposta_correta:
		_acertou()
	else:
		_errou()
# --------------------------------------------------
# ACERTOU
# --------------------------------------------------
func _acertou():
	print("✅ Acertou!")
	
	som_acerto.play()
	
	# Boss perde 1 etapa de vida
	if idx_vida_boss < anims_boss.size() - 1:
		idx_vida_boss += 1

	_atualizar_vida_boss()

	# Se chegou no fim → boss morre
	if idx_vida_boss >= anims_boss.size() - 1:
		await get_tree().create_timer(0.3).timeout
		_boss_morre()
		return

	# Ir para próxima UI
	uis[ui_atual_index].visible = false
	ui_atual_index += 1
	_iniciar_ui()
# --------------------------------------------------
# ERROU
# --------------------------------------------------
func _errou():
	print("❌ Errou!")
	
	som_erro.play()

	if boss.has_node("AnimatedSprite2D"):
		var anim_boss = boss.get_node("AnimatedSprite2D")
		anim_boss.play("dog_attack")

	await get_tree().create_timer(1.3).timeout

	# Volta o cachorro pro idle
	if boss.has_node("AnimatedSprite2D"):
		boss.get_node("AnimatedSprite2D").play("idlle")

	# Player perde 1 etapa de vida
	if idx_vida_player < anims_player.size() - 1:
		idx_vida_player += 1

	_atualizar_vida_player()

	# Se chegou no final → player morre
	if idx_vida_player >= anims_player.size() - 1:
		await get_tree().create_timer(0.3).timeout
		_player_morre()
# --------------------------------------------------
# ATUALIZA VIDA DO PLAYER
# --------------------------------------------------
func _atualizar_vida_player():
	var anim = anims_player[idx_vida_player]
	hp_player.play(anim)
	hp_player.frame = 0  # garante atualização
# --------------------------------------------------
# ATUALIZA VIDA DO BOSS
# --------------------------------------------------
func _atualizar_vida_boss():
	var anim = anims_boss[idx_vida_boss]
	hp_boss.play(anim)
	hp_boss.frame = 0
# --------------------------------------------------
# MORTE DO BOSS
# --------------------------------------------------
func _boss_morre():
	print("🐺 Boss morreu!")
	
	boss.queue_free()
	
	hp_player.visible = false
	
	for ui in uis:
		ui.visible = false
		
	som_fase_concluida.play()
		
	victory_label.visible = true
	victory_label.text = "VOCÊ DERROTOU O GUARDIÃO DO LIVRO!"
		
# --------------------------------------------------
# MORTE DO PLAYER
# --------------------------------------------------
func _player_morre():
	print("💀 Player morreu!")
	get_tree().change_scene_to_file("res://Cenas/game_over.tscn")
