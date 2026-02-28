extends RigidBody3D

@export var dados_do_documento: Resource
@export var textura_aprovado: Texture2D
@export var textura_reprovado: Texture2D

@onready var decal_carimbo: Decal = $Decal # O nó Decal

var status_carimbo: String = ""

func _ready() -> void:
	limpar_carimbo()

func interact():
	if dados_do_documento:
		var ui = get_tree().current_scene.get_node("CanvasLayer")
		
		# Verifica se a sua UI tem a função 
		if ui and ui.has_method("exibir_texto"):
			
			var mensagem = "[b]Voluntário:[/b] " + dados_do_documento.nome_doador + "\n\n[b]Input de memória:[/b] \n" + dados_do_documento.descricao
			mensagem += "\n\n[b]Resumo da memória:[/b] " + dados_do_documento.resumo_descricao
			
			ui.exibir_texto(mensagem, self)

func aplicar_carimbo(tipo: String):
	status_carimbo = tipo
	decal_carimbo.visible = true
	if tipo == "aprovado":
		decal_carimbo.texture_albedo = textura_aprovado
	elif tipo == "reprovado":
		decal_carimbo.texture_albedo = textura_reprovado

func limpar_carimbo():
	status_carimbo = ""
	decal_carimbo.visible = false
