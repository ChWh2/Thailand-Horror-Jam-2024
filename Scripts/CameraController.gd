extends Camera3D

@export var player : CharacterBody3D
@export var neck : Node3D

@export var lookRay : RayCast3D
@export var lookRayDistance : float = 4.0

func _ready():
	lookRay.target_position = Vector3.BACK * lookRayDistance

func _physics_process(delta):
	if lookRay.get_collider():
		position.z = lookRay.get_collision_point().length() - 1.0
	else:
		position.z = lookRayDistance

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion:
		neck.rotate_x(event.relative.y * 0.01)
		
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(30))
		
		player.rotate_y(-event.relative.x * 0.01)
