class_name wendigo
extends CharacterBody3D


@export var slowSpeed = 10.0
@export var fastSpeed = 20.0

@export var attackDist : float
@export var getOutOfViewDist : float
@export var noticeDist : float
@export var loseInterestDist : float
@export var reachDist : float
@export var outOfRangeDist : float
@export var runAwayDist : float

@export var health = 10
@export var headOffset : Vector3

@export var target : Player

@export var terrainNoise : FastNoiseLite

@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var cam : Camera3D = get_viewport().get_camera_3d()
@onready var mesh : Node3D = $Mesh

enum STATES{STALKING, DECIDE_GET_OUT_OF_VIEW_DIRECTION, GETTING_OUT_OF_VIEW, ATTACKING, OUT_OF_RANGE, RUN_AWAY}

var state : STATES = STATES.STALKING
var onScreen = false
var exitScreenRight : bool = false

var frozen : bool = false

func hurt() -> void:
	$Hurt.play()
	
	health -= 1
	state = STATES.RUN_AWAY
	
	if health <= 0:
		print(health)
		SceneSwitcher.switchScene(SceneSwitcher.Scenes.WIN)

func testToChangeState() -> STATES:
	var distance = position.distance_to(target.position)
	
	if state == STATES.STALKING:
		if(distance >= outOfRangeDist):
			return STATES.OUT_OF_RANGE
		elif onScreen:
			if distance > noticeDist:
				if distance < getOutOfViewDist:
					$TimeOnScreen.start()
					return STATES.DECIDE_GET_OUT_OF_VIEW_DIRECTION
			else:
				return STATES.ATTACKING
		elif distance < attackDist:
			return STATES.ATTACKING
		
	elif state == STATES.DECIDE_GET_OUT_OF_VIEW_DIRECTION:
		exitScreenRight = 0 <= cam.unproject_position(position).x - get_viewport().get_visible_rect().size.x/2
		return STATES.GETTING_OUT_OF_VIEW
		
	elif state == STATES.GETTING_OUT_OF_VIEW:
		if !onScreen or distance >= getOutOfViewDist:
			$TimeOnScreen.stop()
			return STATES.STALKING
		
	elif state == STATES.ATTACKING:
		if distance > loseInterestDist:
			if onScreen:
				$TimeOnScreen.start()
				return STATES.DECIDE_GET_OUT_OF_VIEW_DIRECTION
			else:
				return STATES.STALKING
				
	elif state == STATES.OUT_OF_RANGE:
		if(distance <= outOfRangeDist):
			return STATES.STALKING
	
	elif state == STATES.RUN_AWAY:
		if(distance >= runAwayDist):
			return STATES.OUT_OF_RANGE
	
	return state

func stateMachine():
	#changing states
	state = testToChangeState()
	
	#connecting states
	if state == STATES.STALKING:
		stalking()
	elif state == STATES.GETTING_OUT_OF_VIEW:
		getOutOfView()
	elif state == STATES.ATTACKING:
		attacking()
	elif state == STATES.OUT_OF_RANGE:
		outOfRange()
	elif state == STATES.RUN_AWAY:
		runAway()

func _ready():
	$UI/Health.max_value = health
	$UI/Health.value = health

func _physics_process(_delta):
	if !frozen:
		physics_process()

func physics_process():
	if target.justShotGun == true:
		state = STATES.RUN_AWAY
		target.justShotGun = false
	
	look_at(target.position)
	rotation.x = 0.0
	rotation.z = 0.0
	
	position.y = terrainNoise.get_noise_2d(position.x, position.z) * 20.0
	
	stateMachine()
	move_and_slide()
	animMananger()
	
	if velocity.x != 0.0 or velocity.z != 0.0:
		mesh.look_at(Vector3(velocity.x, 0.0, velocity.z) + mesh.global_position)
	
	$UI/Health.value = health
	

func stalking():

	var direction = (transform.basis * Vector3(0, 0, -1)).normalized()
	
	if direction:
		velocity.x = slowSpeed * direction.x
		velocity.z = slowSpeed * direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, slowSpeed)
		velocity.z = move_toward(velocity.z, 0, slowSpeed)

func getOutOfView():
	
	var x
	if exitScreenRight:
		x = -1
	else:
		x = 1
	
	var direction = (transform.basis * Vector3(x, 0, 0)).normalized()
	
	velocity.x = fastSpeed * direction.x
	velocity.z = fastSpeed * direction.z

func attacking():
	var direction = (transform.basis * Vector3(0, 0, -1)).normalized()
	
	var distance = position.distance_to(target.position)
	
	if(distance > reachDist):
		velocity.x = fastSpeed * direction.x
		velocity.z = fastSpeed * direction.z
	else:
		velocity.x = 0
		velocity.z = 0
		
		position = target.position + target.position.direction_to(position)
		
		frozen = true
		target.dying = true
		$UI/Health.hide()
		$UI/RedOutline.show()
		$Attack.play()
	

func outOfRange():
	var direction = (transform.basis * Vector3(0, 0, -1)).normalized()
	
	velocity.x = fastSpeed * direction.x
	velocity.z = fastSpeed * direction.z

func runAway():
	var direction = (transform.basis * Vector3(0, 0, 1)).normalized()
	
	velocity.x = fastSpeed * direction.x
	velocity.z = fastSpeed * direction.z

func animMananger():
	if frozen:
		animPlayer.play("Attacking")
	elif velocity.x or velocity.z:
		animPlayer.play("Running")
	else:
		animPlayer.play("Idle")

func _on_onscreen_screen_entered():
	onScreen = true

func _on_onscreen_screen_exited():
	onScreen = false

func _on_time_on_screen_timeout():
	state = STATES.ATTACKING


func _on_attack_sound_finished():
	SceneSwitcher.switchScene(SceneSwitcher.Scenes.LOSE)
