@tool
extends MeshInstance3D

@export var update = false

@export var size : int = 1.0
@export var resolution : int = 1.0
@export var centerOffset = 0.0
@export var noiseOffset = 0.0
@export var maxTerrainHeight = 1.0

@onready var noise = FastNoiseLite.new()

func _ready():
	noise.noise_type=FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.025

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		update = false
		updateMesh()

func updateMesh():
	var arrayMesh : ArrayMesh
	var collision = ConcavePolygonShape3D.new()
	var surfTool = SurfaceTool.new()
	
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(resolution+1):
		for x in range(resolution+1):
			
			var percent = Vector2(x,z)/resolution
			var pointOnMesh = Vector3((percent.x-centerOffset), 0, (percent.y-centerOffset))
			var vertex = pointOnMesh * size
			
			vertex.y = noise.get_noise_2d(vertex.x+noiseOffset,vertex.z+noiseOffset) * maxTerrainHeight
			
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
