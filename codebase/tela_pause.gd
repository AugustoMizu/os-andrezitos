extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tecla_p"):
		get_viewport().set_input_as_handled()
		toggle_pause()

func toggle_pause() -> void:
	var esta_pausado: bool = !get_tree().paused
	get_tree().paused = esta_pausado
	visible = esta_pausado
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if esta_pausado else Input.MOUSE_MODE_CAPTURED

func _on_continuar_pressed() -> void:
	toggle_pause()
	
func _on_sair_pressed()->void:
	get_tree().quit()
