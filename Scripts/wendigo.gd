extends CharacterBody3D


@export var speed = 10.0
@export var attemptStalkDist : float = 50.0
@export var StalkDistLeeway : float = 5.0

@export var target : Player

@export var terrainNoise : FastNoiseLite

@onready var animPlayer : AnimationPlayer = $AnimationPlayer

enum STATES{STALKING, ATTACKING}

var state : STATES = STATES.STALKING

func _physics_process(_delta):
	
	look_at(target.position)
	rotation.x = 0.0
	rotation.z = 0.0
	
	position.y = terrainNoise.get_noise_2d(position.x, position.z) * 20.0
	
	if state == STATES.STALKING:
		stalking()
	elif state == STATES.ATTACKING:
		attacking()
	move_and_slide()
	
	animMananger()

func stalking():
	var dist = position.distance_to(target.position)
	
	var z : int
	if(dist > attemptStalkDist + StalkDistLeeway):
		z = -1
	elif(dist < attemptStalkDist - StalkDistLeeway):
		z = 1
	else:
		z = 0
	
	var direction = (transform.basis * Vector3(0, 0, z)).normalized()
	
	if direction:
		velocity.x = speed * direction.x
		velocity.z = speed * direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func attacking():
	var direction = (transform.basis * Vector3(0, 0, 1)).normalized()
	
	velocity.x = speed * direction.x
	velocity.z = speed * direction.z

func animMananger():
	if velocity.x or velocity.z:
		animPlayer.play("Running")
	else:
		animPlayer.play("Idle")
