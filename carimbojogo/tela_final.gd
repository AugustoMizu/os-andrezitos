extends Control

@onready var label = $resultado_label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Global.pontuacao_final >= 250: 
		label.text = "FINAL BOM: Você foi demitido e manteve sua humanidade! Você fez um pessimo trabalho. \n" + Global.pontuacao_finall
	else:
		label.text = "FINAL RUIM: A IA corrompeu sua mente. Você agora é parte do sistema. Você enviar muitos arquivos corretos\n" + Global.pontuacao_finall
