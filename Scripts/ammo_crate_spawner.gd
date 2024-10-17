extends Node3D

@export var ammoCrate : PackedScene
@export var player : Player

@export var maxCrates : int

@export var maxDistance : float

@export var terrainNoise : FastNoiseLite

var crates : Array[ammoBox]

func _process(_delta: float) -> void:
	var removeArray : Array[int] = []
	
	var n = 0
	
	for i in crates.size():
		if !is_instance_valid(crates[i-n]):
			crates.remove_at(i-n)
			n += 1
	
	for i in crates.size():

		if is_instance_valid(crates[i]) and Vector2(crates[i].position.x, crates[i].position.z).distance_to(Vector2(player.position.x, player.position.z)) > maxDistance:
			removeArray.append(i)
	
	removeArray.sort()
	removeArray.reverse()
	
	for i in removeArray:
		var oldCrate = crates[i]
		crates.remove_at(i)
		oldCrate.queue_free()
	
	if crates.size() < maxCrates:
		for i in maxCrates - crates.size():
			var newCrate = ammoCrate.instantiate()
			
			var randX = randf() - 0.5
			var randY = randf() - 0.5
			
			var direction = Vector3(randX, 0, randY).normalized()
			
			newCrate.position = player.position + direction * maxDistance
			newCrate.position.y = terrainNoise.get_noise_2d(newCrate.position.x, newCrate.position.z) * 20.0
			add_child(newCrate)
			crates.append(newCrate)
