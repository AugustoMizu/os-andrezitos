extends CanvasLayer

@onready var janela = $JanelaLeitura
@onready var label_texto = $JanelaLeitura/TextoDocumento


@onready var btn_aprovar = $JanelaLeitura/Button 
@onready var btn_reprovar = $JanelaLeitura/Button2

var documento_atual: RigidBody3D = null

func exibir_texto(conteudo: String, doc: RigidBody3D):
	documento_atual = doc
	label_texto.text = conteudo
	janela.visible = true
	
	# A MÁGICA ACONTECE AQUI MEUS BORTHERS:
	if doc.status_carimbo == "":
		btn_aprovar.visible = true
		btn_reprovar.visible = true
	else:
		btn_aprovar.visible = false
		btn_reprovar.visible = false
		
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_aprovar_pressed():
	if documento_atual and documento_atual.has_method("aplicar_carimbo"):
		documento_atual.aplicar_carimbo("aprovado")
	fechar_interface()
	
func _on_reprovar_pressed():
	if documento_atual and documento_atual.has_method("aplicar_carimbo"):
		documento_atual.aplicar_carimbo("reprovado")
	fechar_interface()


func _on_fechar_pressed():
	fechar_interface() 


func fechar_interface():
	janela.visible = false
	documento_atual = null
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
