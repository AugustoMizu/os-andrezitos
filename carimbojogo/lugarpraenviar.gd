extends Area3D

@export var ponto_de_retorno: Node3D 

@onready var som_recebido: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if "status_carimbo" in body:
		if body.status_carimbo != "":
			enviar_documento(body)
		else:
			print("Documento sem carimbo! Rejeitado pela máquina.")

func enviar_documento(papel: RigidBody3D):
	print("Enviado com sucesso! Carimbo: ", papel.status_carimbo)
	
	# TOCA O SOM AQUI!
	if som_recebido:
		som_recebido.play()
	
	var camera = get_viewport().get_camera_3d()
	if camera.objeto_segurado == papel:
		camera.soltar_objeto()
		
	papel.visible = false
	papel.freeze = true 
	papel.global_position = Vector3(0, -100, 0) 
	
	await get_tree().create_timer(5.0).timeout
	
	papel.limpar_carimbo()
	
	if ponto_de_retorno:
		papel.global_position = ponto_de_retorno.global_position
		
	papel.linear_velocity = Vector3.ZERO
	papel.angular_velocity = Vector3.ZERO
	
	papel.freeze = false 
	papel.visible = true
	print("Novo documento na impressora!")
