extends Node3D

@onready var occult = $occult

func _ready():
	occult.play()

func _process(_delta):
	pass
