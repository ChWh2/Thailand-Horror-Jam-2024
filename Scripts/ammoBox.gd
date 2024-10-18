class_name ammoBox
extends Area3D

@onready var audio = $AudioStreamPlayer3D

var used = false

func _on_body_entered(body):
	if body is Player and !used:
		used = true
		body.ammo += 1

		$Ammo_Box_Open.hide()
		
		audio.play()
		


func _on_audio_stream_player_3d_finished():
	queue_free()
