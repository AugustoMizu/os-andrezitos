extends Camera3D

@export var mouse_sensitivity: float = 0.002
@export var max_yaw_degrees: float = 90.0 # limite de movimento horizontal
@export var max_pitch_degrees: float = 80.0 # limite movimento vertical
@onready var interact_ray: RayCast3D = $InteractRay 

# movimentar a tela
var yaw: float = 0.0
var pitch: float = 0.0
var start_yaw: float = 0.0

# para mover objetos moveis
var objeto_segurado: RigidBody3D = null
var distancia_segurando: float = 1.0 

func _ready() -> void:
	# usa o movimento do mouse para mover a tela
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_yaw = rotation.y
	yaw = start_yaw
	pitch = rotation.x

func _unhandled_input(event: InputEvent) -> void:
	# solta o mouse com ESC, podemos usar isso para pausar o jogo
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseButton:
		# clique esquerdo interagir
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if interact_ray.is_colliding():
				var hit = interact_ray.get_collider()
				if hit.has_method("interact"): hit.interact()
		
		# clique direito segurar
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed: pegar_objeto()
			else: soltar_objeto()


	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		girar_camera(event.relative)

func _physics_process(_delta: float) -> void:
	# logica para o objeto seguir a mira
	if objeto_segurado:
		var alvo = global_position - global_transform.basis.z * distancia_segurando
		objeto_segurado.linear_velocity = (alvo - objeto_segurado.global_position) * 20.0
		objeto_segurado.angular_velocity = Vector3.ZERO

func pegar_objeto():
	if interact_ray.is_colliding():
		var colisor = interact_ray.get_collider()
		if colisor is RigidBody3D:
			objeto_segurado = colisor
			objeto_segurado.gravity_scale = 0.0

func soltar_objeto():
	if objeto_segurado:
		objeto_segurado.gravity_scale = 1.0
		objeto_segurado = null

func girar_camera(relative: Vector2):
	# calcula a nova rotação
	yaw -= relative.x * mouse_sensitivity
	pitch -= relative.y * mouse_sensitivity
	
	# aplica limites de movimento
	var y_lim = deg_to_rad(max_yaw_degrees)
	var p_lim = deg_to_rad(max_pitch_degrees)
	yaw = clamp(yaw, start_yaw - y_lim, start_yaw + y_lim)
	pitch = clamp(pitch, -p_lim, p_lim)
	
	# gira a câmera
	rotation.x = pitch
	rotation.y = yaw
