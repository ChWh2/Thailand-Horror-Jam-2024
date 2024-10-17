class_name Player
extends CharacterBody3D

@export var speed = 5.0

var dying = false

var ammo : int = 1

var justShotGun : bool = false

@onready var camera = $Neck/Camera3D

@export var Wendigo : wendigo

func shoot():
	if(ammo > 0):
		if $Neck/GunRay.get_collider() is wendigo:
			$Neck/GunRay.get_collider().hurt()
		
		justShotGun = true
		ammo -= 1
		$UI/GunCamera/SubViewport/GunShotParticles.emitting = true
		#playSound

func _physics_process(delta):
	if !dying:
		physics_process(delta)
	else:
		velocity = Vector3.ZERO
		camera.stare(Vector3(Wendigo.position + Wendigo.headOffset))

func physics_process(delta):
	$UI/Ammo.text = str("Ammo: ", ammo)
	
	if Input.is_action_just_pressed("Shoot"):
		shoot()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("Left", "Right", "Up","Down")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
