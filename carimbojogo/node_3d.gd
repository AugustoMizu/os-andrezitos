extends Node3D

@export_category("Configuração de Memórias")
@export var memoria_lore: Memoria
@export var posicao_lore: int = 7 # posição do doc da beatriz imolação na lista, lore do jogo
@export var total_documentos: int = 15
@export var qtd_docs_inicial: int = 3 # quantidade de docs no inicio sem menção a perda de memoria
# posicao_lore e qtd_docs_inicial NÃO pode ser maior que o total_documentos

@export_category("Referências da Cena")
@export var documento_papel: RigidBody3D
@export var lugar_pra_voltar: Node3D
@export var lugar_pra_enviar: Area3D
@export var camera_jogador: Camera3D

@export_category("Cenas Finais")
@export var cena_vitoria: PackedScene
@export var cena_derrota: PackedScene


var pool_memorias: Array[Memoria] = []
var fila: Array[Memoria] = []
var mesa_ocupada: bool = false
var pontuacao_global: int = 0 # Variável para controlar os pontos

func _ready() -> void:
	randomize()
	carregar_memorias_da_pasta()
	
	lugar_pra_enviar.body_entered.connect(_on_lugar_pra_enviar_body_entered)
	

	montar_fila()
	imprimir_proximo_documento()

func carregar_memorias_da_pasta() -> void:
	var caminho_pasta = "res://data/memorias/"
	var dir = DirAccess.open(caminho_pasta)
	
	if dir:
		dir.list_dir_begin()
		var nome_arquivo = dir.get_next()
		
		while nome_arquivo != "":
			if not dir.current_is_dir():
				# Remove o ".remap" se ele existir (acontece apenas no jogo exportado)
				var arquivo_real = nome_arquivo.trim_suffix(".remap")
				
				# Agora a checagem funciona yey!
				if arquivo_real.ends_with(".tres"):
					var caminho_completo = caminho_pasta + arquivo_real
					var memoria_carregada = load(caminho_completo) as Memoria
					
					if memoria_carregada and memoria_carregada != memoria_lore:
						pool_memorias.append(memoria_carregada)
						
			nome_arquivo = dir.get_next()
			
		print("Sucesso! ", pool_memorias.size(), " memórias carregadas automaticamente.")
	else:
		print("Erro: Não foi possível acessar a pasta ", caminho_pasta)

func montar_fila():
	if pool_memorias.is_empty():
		print("ATENÇÃO: Nenhuma memória encontrada na pasta!")
		return
		
	pool_memorias.shuffle()
	var pool_temporaria = pool_memorias.duplicate()
	
	var docs_iniciais = [] # sem lore
	var docs_comuns = [] # com lore

	for doc in pool_temporaria:
		if doc.get("doc_inicial") == true:
			docs_iniciais.append(doc)
		else:
			docs_comuns.append(doc)
		
	for i in total_documentos:
		if i == posicao_lore and memoria_lore != null:
			fila.append(memoria_lore)
		else:
			if fila.size() < qtd_docs_inicial and docs_iniciais.size() > 0:
				fila.append(docs_iniciais.pop_back())
			else:
				if docs_iniciais.size() > 0: 
					fila.append(docs_iniciais.pop_back())
				elif docs_comuns.size() > 0:
					fila.append(docs_comuns.pop_back())
					
	print("Fila montada com ", fila.size(), " documentos.")
	print("Documentos na fila \n", fila)

func imprimir_proximo_documento() -> void:
	if fila.is_empty():
		print("Não há mais documentos. Fim do expediente!")
		finalizar_expediente() # Chama a função que verifica o treco
		return
		
	var proxima_memoria = fila.pop_front()
	
	documento_papel.dados_do_documento = proxima_memoria
	print("Imprimindo documento de: ", proxima_memoria.nome_doador)
	
	documento_papel.linear_velocity = Vector3.ZERO
	documento_papel.angular_velocity = Vector3.ZERO
	documento_papel.freeze = false
	documento_papel.limpar_carimbo()
	
	if lugar_pra_voltar:
		documento_papel.global_position = lugar_pra_voltar.global_position
	
	documento_papel.visible = true
	mesa_ocupada = true
	
	var som = get_node_or_null("lugarpravoltar/AudioNovoDoc")
	if som: som.play()

func _on_lugar_pra_enviar_body_entered(body: Node3D) -> void:
	if body == documento_papel:
		if documento_papel.status_carimbo != "":
			processar_documento()
		else:
			print("Ei, você esqueceu de carimbar!")

func processar_documento() -> void:
	print("Documento carimbado como '", documento_papel.status_carimbo, "' enviado. Processando...")
	
	var memoria_atual = documento_papel.dados_do_documento as Memoria
	
	if memoria_atual.resumo_certo == true and documento_papel.status_carimbo == "aprovado":
		pontuacao_global += 1
		print("\nPonto ganho! Pontuação atual: ", pontuacao_global)		
	elif memoria_atual.resumo_certo == false and documento_papel.status_carimbo == "reprovado":
		pontuacao_global += 1
		print("\nPonto ganho! Pontuação atual: ", pontuacao_global)		
	else:
		pontuacao_global -= 1
		print("\nPonto ganho! Pontuação atual: ", pontuacao_global)		
	
	var som = lugar_pra_enviar.get_node_or_null("AudioStreamPlayer3D")
	if som: som.play()
	
	if camera_jogador.objeto_segurado == documento_papel:
		camera_jogador.soltar_objeto()
		
	documento_papel.visible = false
	documento_papel.freeze = true
	documento_papel.global_position = Vector3(0, -100, 0)
	
	mesa_ocupada = false
	
	await get_tree().create_timer(3.0).timeout
	
	imprimir_proximo_documento()

func finalizar_expediente() -> void:
	print("Expediente encerrado. Pontuação Final: ", pontuacao_global)
	
	if pontuacao_global >= 7:
		if cena_derrota:
			get_tree().change_scene_to_packed(cena_derrota)
		else:
			print("ERRO: cena_derrota não foi definida no inspetor!")
	else:
		if cena_vitoria:
			get_tree().change_scene_to_packed(cena_vitoria)
		else:
			print("ERRO: cena_vitoria não foi definida no inspetor!")
		
		
