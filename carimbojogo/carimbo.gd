extends StaticBody3D

@export var tipo_deste_carimbo: String = "aprovado" # Mude para "reprovado" no outro
var posicao_original: Vector3
var animando: bool = false

func _ready() -> void:
	posicao_original = position

func interact() -> void:
	if animando: return 
	
	var camera = get_viewport().get_camera_3d() 
	
	animando = true
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", posicao_original.y - 0.1, 0.1)
	
	tween.tween_callback(func():
		if camera.objeto_segurado and camera.objeto_segurado.has_method("aplicar_carimbo"):
			camera.objeto_segurado.aplicar_carimbo(tipo_deste_carimbo)
	)
	
	tween.tween_property(self, "position:y", posicao_original.y, 0.15)
	
	tween.tween_callback(func(): animando = false)
