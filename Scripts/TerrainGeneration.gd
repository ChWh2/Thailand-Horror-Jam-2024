@tool
extends StaticBody3D

@export var update = false

@export var meshInstance : MeshInstance3D

@export var size : int = 1.0

@export var resolution : int = 1

@onready var noise = FastNoiseLite.new()

func _ready():
	noise.noise_type=FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.5

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
	
	for z in range(size*resolution+1):
		for x in range(size*resolution+1):
			var y = noise.get_noise_2d(float(x)/float(resolution),float(z)/float(resolution)) * 2.0
			
			var uv = Vector2.ZERO
			uv.x = inverse_lerp(0, size*resolution, x)
			uv.y = inverse_lerp(0, size*resolution, z)
			surfTool.set_uv(uv)
			
			surfTool.add_vertex(Vector3(float(x)/float(resolution) - float(size)/2.0, y, float(z)/float(resolution)-float(size)/2.0))
	
	var vert = 0
	for z in size*resolution:
		for x in size*resolution:
			surfTool.add_index(vert)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+1+size*resolution)
			
			surfTool.add_index(vert+1+size*resolution)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+2+size*resolution)
			vert += 1
		vert += 1

	surfTool.generate_normals()
	surfTool.generate_tangents()
	arrayMesh = surfTool.commit()
	
	meshInstance.mesh = arrayMesh
