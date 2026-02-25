extends CanvasLayer

@onready var janela = $JanelaLeitura
@onready var label_texto = $JanelaLeitura/TextoDocumento

func exibir_texto(conteudo: String):
	label_texto.text = conteudo
	janela.visible = true
	# libera o mouse para clicar no botao fechar
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

# fechar a tela de leitura
func _on_fechar_pressed():
	janela.visible = false
	# prende o mouse no jogo de novo
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
