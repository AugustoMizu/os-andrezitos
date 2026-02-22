extends StaticBody3D

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var is_on: bool = false

#faz o audio tocarks
func interact() -> void:
	if is_on:
		audio_player.stop()
		is_on = false
	else:
		audio_player.play()
		is_on = true
