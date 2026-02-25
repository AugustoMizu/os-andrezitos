extends RigidBody3D

@export var dados_do_documento: Resource 

func interact():
	if dados_do_documento:
		var ui = get_tree().current_scene.get_node("CanvasLayer")
		if ui:
			var mensagem = "[b]Voluntário:[/b] " + dados_do_documento.nome_doador + "\n\n[b]Input de memória:[/b] \n" + dados_do_documento.descricao
			mensagem += "\n\n[b]Resumo da memória:[/b] " + dados_do_documento.resumo_descricao
			ui.exibir_texto(mensagem)
