extends CharacterBody3D


@export var speed = 5.0

@export var body : Node3D

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if velocity.x or velocity.z:
		body.look_at(body.global_position + Vector3(velocity.x, 0, velocity.z))
	
	move_and_slide()
