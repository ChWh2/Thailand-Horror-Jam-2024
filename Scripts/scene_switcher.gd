extends Node

var main = preload("res://Scenes/main.tscn")

enum Scenes{TITLE,MAIN,END}

func switchScene(scene : Scenes):
	if scene == Scenes.MAIN:
		get_tree().change_scene_to_file(main)
	elif scene == Scenes.TITLE:
		print("Title")
		get_tree().quit()
	elif scene == Scenes.END:
		print("end")
		get_tree().quit()
