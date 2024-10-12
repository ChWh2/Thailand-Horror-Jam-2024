extends Node3D

@export var chunkSize = 200
@export var terrainHeight = 20
@export var viewDist = 1000
@export var player : CharacterBody3D

@export var chunkMeshScene : PackedScene

var playerPos = Vector2.ZERO
var chunks = {}
var chunksVisible = 0
var lastVisibleChunks : Array[terrainChunk]

@export var noise : FastNoiseLite

func _ready():
	chunksVisible= roundi(float(viewDist)/float(chunkSize))
	#setWireframe()
	updateVisibleChunks()

func _process(_delta):
	playerPos = Vector2(player.position.x, player.position.z)
	updateVisibleChunks()

func setWireframe():
	RenderingServer.set_debug_generate_wireframes(true)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME

func updateVisibleChunks():
	for chunk in lastVisibleChunks:
		chunk.setChunkVisible(false)
	lastVisibleChunks.clear()
	
	var currentX = roundi(playerPos.x/chunkSize)
	var currentY = roundi(playerPos.y/chunkSize)
	
	for yOffset in range(-chunksVisible, chunksVisible):
		for xOffset in range(-chunksVisible, chunksVisible):
			var viewChunkCoord = Vector2(currentX-xOffset, currentY-yOffset)
			if chunks.has(viewChunkCoord):
				chunks[viewChunkCoord].updateChunk(playerPos, viewDist)
				if(chunks[viewChunkCoord].updateLOD(playerPos)):
					chunks[viewChunkCoord].generateTerrain(noise, viewChunkCoord,chunkSize, true)
			else:
				var newChunk : terrainChunk = chunkMeshScene.instantiate()
				add_child(newChunk)
				newChunk.maxTerrainHeight = terrainHeight
				var pos = viewChunkCoord * chunkSize
				var worldPos = Vector3(pos.x, 0, pos.y)
				
				newChunk.global_position = worldPos
				newChunk.generateTerrain(noise, viewChunkCoord, chunkSize, false)
				chunks[viewChunkCoord] = newChunk
