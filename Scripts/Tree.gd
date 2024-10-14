class_name tree
extends Node3D

@export var treeMeshes : Array[PackedScene]

func pickTree():
	
	var index = int(position.x + position.y + position.z)
	index %= treeMeshes.size()
	
	var treeMesh = treeMeshes[index].instantiate()
	add_child(treeMesh)
