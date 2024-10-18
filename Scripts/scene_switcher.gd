extends Node

var main : NodePath = "res://Scenes/main.tscn"

var title : NodePath =  "res://Scenes/title.tscn"
var lose : NodePath = "res://Scenes/lose.tscn"
var win : NodePath = "res://Scenes/win.tscn"

enum Scenes{TITLE,MAIN,WIN,LOSE}

func switchScene(scene : Scenes):
	if scene == Scenes.MAIN:
		get_tree().change_scene_to_file(main)
	elif scene == Scenes.TITLE:
		get_tree().change_scene_to_file(title)
	elif scene == Scenes.WIN:
		get_tree().change_scene_to_file(win)
	elif scene == Scenes.LOSE:
		get_tree().change_scene_to_file(lose)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
