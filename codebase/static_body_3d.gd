extends StaticBody3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var is_on: bool = true

func _ready() -> void:
	wait(3)
	await(wait(2))
	audio_player.play()
	is_on = true
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

#faz o audio tocarks
func interact() -> void:
	if is_on:
		audio_player.stop()
		is_on = false
	else:
		audio_player.play()
		is_on = true
