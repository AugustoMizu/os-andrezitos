extends Camera3D

@export var mouse_sensitivity: float = 0.002
@export var max_yaw_degrees: float = 90.0 
@export var max_pitch_degrees: float = 80.0 
@onready var interact_ray: RayCast3D = $InteractRay 

var yaw: float = 0.0
var pitch: float = 0.0
var start_yaw: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_yaw = rotation.y
	yaw = start_yaw
	pitch = rotation.x

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#se o ray ta pegando algo
			if interact_ray.is_colliding():
				var hit_object = interact_ray.get_collider()
				if hit_object.has_method("interact"):
					hit_object.interact()
					
	# a parte de olhar
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		var yaw_limit: float = deg_to_rad(max_yaw_degrees)
		var pitch_limit: float = deg_to_rad(max_pitch_degrees)
		
		yaw = clamp(yaw, start_yaw - yaw_limit, start_yaw + yaw_limit)
		pitch = clamp(pitch, -pitch_limit, pitch_limit)
		
		transform.basis = Basis()
		rotate_y(yaw)
		rotate_object_local(Vector3.RIGHT, pitch)
