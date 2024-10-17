class_name FPSCamera
extends Camera3D

@export var player : CharacterBody3D
@export var neck : Node3D

var frozen = false

func stare(Position : Vector3):
	look_at(Position)
	frozen = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if !frozen:
		if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			neck.rotate_x(-event.relative.y * 0.01)
			neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			player.rotate_y(-event.relative.x * 0.01)
	
	if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
