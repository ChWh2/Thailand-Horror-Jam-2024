extends Node

var main : NodePath = "res://Scenes/main.tscn"

var title = "res://Scenes/title.tscn"

enum Scenes{TITLE,MAIN,WIN,LOSE}

func switchScene(scene : Scenes):
	if scene == Scenes.MAIN:
		get_tree().change_scene_to_file(main)
	elif scene == Scenes.TITLE:
		print("Title")
		get_tree().change_scene_to_packed(title)
	elif scene == Scenes.WIN:
		print("win")
		get_tree().quit()
	elif scene == Scenes.LOSE:
		print("lose")
		get_tree().quit()
