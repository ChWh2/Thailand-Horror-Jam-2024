class_name terrainChunk
extends MeshInstance3D

@export var terrainSize : int = 1
@export var resolution : int = 1
@export var maxTerrainHeight = 1.0
@export var terrainNoise : FastNoiseLite

@export var tree : PackedScene
@export var treeDensity : int = 1
@export var maxTreeOffset : float = 1.0
@export var treeNoise : FastNoiseLite

var ChunkLODs = [5,10,25,40]
var positionCoords = Vector2.ZERO
const CENTER_OFFSET = 0.5

var setCollision = false

func generateTerrain(coords:Vector2,size:int, initially_visible:bool) -> void:
	terrainSize=size
	positionCoords = coords * size
	
	var arrayMesh : ArrayMesh
	var surfTool = SurfaceTool.new()
	
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(resolution+1):
		for x in range(resolution+1):
			
			var percent = Vector2(x,z)/resolution
			var pointOnMesh = Vector3((percent.x-CENTER_OFFSET), 0, (percent.y-CENTER_OFFSET))
			var vertex = pointOnMesh * terrainSize
			
			vertex.y = terrainNoise.get_noise_2d(vertex.x+positionCoords.x,vertex.z+positionCoords.y) * maxTerrainHeight
			
			var uv = Vector2.ZERO
			uv.x = percent.x
			uv.y = percent.y
			
			surfTool.set_uv(uv)
			surfTool.add_vertex(vertex)
	
	var vert = 0
	for z in resolution:
		for x in resolution:
			surfTool.add_index(vert)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+1+resolution)
			
			surfTool.add_index(vert+1+resolution)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+2+resolution)
			vert += 1
		vert += 1

	surfTool.generate_normals()
	surfTool.generate_tangents()
	arrayMesh = surfTool.commit()
	
	mesh = arrayMesh
	
	if setCollision == true:
		genCollision()
	
	setChunkVisible(initially_visible)
	
	generateTrees()

func setChunkVisible(visibility : bool) -> void:
	visible = visibility

func updateChunk(viewPos:Vector2,maxViewDist : float) -> void:
	var viewerDist = positionCoords.distance_to(viewPos)
	var isVisible = viewerDist < maxViewDist
	setChunkVisible(isVisible)

func updateLOD(viewPos:Vector2) -> bool:
	var viewerDist = positionCoords.distance_to(viewPos)
	var updateTerrain = false
	var newLOD = 0
	if viewerDist > 300:
		newLOD = ChunkLODs[0]
	elif viewerDist >= 200:
		newLOD = ChunkLODs[1]
	elif viewerDist >= 150:
		newLOD = ChunkLODs[2]
	else:
		newLOD = ChunkLODs[3]
		setCollision = true
	
	if resolution != newLOD:
		resolution = newLOD
		updateTerrain = true
	return updateTerrain

func genCollision() -> void:
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()
	create_trimesh_collision()

func generateTrees():
	for z in range(treeDensity):
		for x in range(treeDensity):
			var percent = Vector2(x,z)/treeDensity
			var pointOnMesh = Vector3((percent.x-CENTER_OFFSET), 0, (percent.y-CENTER_OFFSET))
			var vertex = pointOnMesh * terrainSize
			
			if(treeNoise.get_noise_2d(vertex.x+positionCoords.x,vertex.z+positionCoords.y) > -0.5):
				var newTree = tree.instantiate()
				add_child(newTree)
				newTree.position = vertex
				
				newTree.position.y = terrainNoise.get_noise_2d(vertex.x+positionCoords.x,vertex.z+positionCoords.y) * maxTerrainHeight - 1.0
