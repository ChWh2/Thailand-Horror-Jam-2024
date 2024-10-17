extends Node3D

@onready var occult = $occult

func _ready():
	occult.play()

func _process(_delta):
	occult.volume_db = Settings.MasterVolume + Settings.MusicVolume
