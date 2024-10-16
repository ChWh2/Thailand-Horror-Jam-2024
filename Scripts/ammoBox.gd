class_name ammoBox
extends Area3D

func _on_body_entered(body):
	if body is Player:
		body.ammo += 1
		queue_free()
