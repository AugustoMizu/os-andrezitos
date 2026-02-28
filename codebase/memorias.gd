extends Resource
class_name Memoria

enum TipoMemoria {TECNICA, AFETIVA, MOTORA, CRIATIVA}

@export                 var nome_doador: String = ""
@export                 var tipo: TipoMemoria = TipoMemoria.TECNICA
@export_range(0, 100)   var pontos: int = 0
@export				    var doc_inicial: bool = false #documento antes do personagem perder as memorias, não mostrar que a ia rouba memorias
												# pode usar esse ou o "resumo_certo", leva ao final BOM 'demitido'

@export                 var carimbo_aprovado: bool # o player carimbou essas memoria como 'aprovado' para enviar
@export                 var resumo_certo: bool # se true o resumo da memoria feito pela "ia" está correto, leva ao final em que a "ia" ganha player morrea
											   # se false o resumo tem alucinações, o player deve carimbar como'reprovado'

@export_multiline       var descricao: String = ""
@export_multiline       var resumo_descricao: String = "" # resumo da memoria feita pela "ia"

# varios "resumo_certo" false com "carimbo_aprovado" true podem levar ao final BOM, 'demitido'
