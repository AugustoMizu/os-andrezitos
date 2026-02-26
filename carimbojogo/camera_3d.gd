extends Camera3D

@export var mouse_sensitivity: float = 0.002
@export var max_yaw_degrees: float = 121.0 
@export var max_pitch_degrees: float = 80.0 
@onready var interact_ray: RayCast3D = $InteractRay 

@export var objeto_misterioso: Node3D 
@export var tempo_para_aparecer: float = 5 
@export var tempo_para_sumir: float = 0.2    

@export var som_sumico: AudioStreamPlayer 

var ja_apareceu: bool = false
var tempo_olhando: float = 0.0 

var yaw: float = 0.0
var pitch: float = 0.0
var start_yaw: float = 0.0

var objeto_segurado: RigidBody3D = null
var distancia_segurando: float = 1.0 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_yaw = rotation.y
	yaw = start_yaw
	pitch = rotation.x
	
	if objeto_misterioso:
		objeto_misterioso.hide() 
		await get_tree().create_timer(tempo_para_aparecer).timeout
		if is_instance_valid(objeto_misterioso):
			objeto_misterioso.show()
			ja_apareceu = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if interact_ray.is_colliding():
				var hit = interact_ray.get_collider()
				if hit.has_method("interact"):
					hit.interact()

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		girar_camera(event.relative)

func _physics_process(delta: float) -> void:
	if ja_apareceu and is_instance_valid(objeto_misterioso):
		var esta_olhando = false
		
		if interact_ray.is_colliding():
			var hit = interact_ray.get_collider()
			if hit == objeto_misterioso or hit.is_ancestor_of(objeto_misterioso) or objeto_misterioso.is_ancestor_of(hit):
				esta_olhando = true
		
		if esta_olhando:
			tempo_olhando += delta
			if tempo_olhando >= tempo_para_sumir:
				if som_sumico:
					som_sumico.play()
				objeto_misterioso.queue_free() 
		else:
			tempo_olhando = 0.0 

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if objeto_segurado == null:
			pegar_objeto()
		else:
			var alvo = global_position - global_transform.basis.z * distancia_segurando
			objeto_segurado.linear_velocity = (alvo - objeto_segurado.global_position) * 20.0
			objeto_segurado.angular_velocity = Vector3.ZERO
	else:
		if objeto_segurado != null:
			soltar_objeto()

func pegar_objeto():
	interact_ray.force_raycast_update()
	if interact_ray.is_colliding():
		var colisor = interact_ray.get_collider()
		if colisor is RigidBody3D:
			objeto_segurado = colisor
			objeto_segurado.gravity_scale = 0.0
			objeto_segurado.sleeping = false 

func soltar_objeto():
	if objeto_segurado:
		objeto_segurado.gravity_scale = 1.0
		objeto_segurado = null

func girar_camera(relative: Vector2):
	yaw -= relative.x * mouse_sensitivity
	pitch -= relative.y * mouse_sensitivity
	var y_lim = deg_to_rad(max_yaw_degrees)
	var p_lim = deg_to_rad(max_pitch_degrees)
	yaw = clamp(yaw, start_yaw - y_lim, start_yaw + y_lim)
	pitch = clamp(pitch, -p_lim, p_lim)
	rotation.x = pitch
	rotation.y = yaw
