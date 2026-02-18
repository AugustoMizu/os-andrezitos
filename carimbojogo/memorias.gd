extends Resource
class_name Memoria

enum TipoMemoria {TECNICA, AFETIVA, MOTORA, CRIATIVA, TRAUMATICA}

@export                 var nome_doador: String = ""
@export                 var tipo: TipoMemoria = TipoMemoria.TECNICA
@export_range(0, 100)   var pontos_ia: int = 0
@export_range(0.0, 1.0) var perigo: float = 0.0
@export                 var carimbo_aprovado: bool
@export_multiline       var descricao: String = ""
@export_multiline       var resumo_descricao: String = ""
