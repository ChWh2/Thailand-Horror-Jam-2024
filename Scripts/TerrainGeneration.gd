@tool
extends StaticBody3D

@export var update = false

@export var meshInstance : MeshInstance3D
@export var collisionShape : CollisionShape3D

@export var xSize : int = 1.0
@export var zSize : int = 1.0

@onready var lastpos : Vector3 = global_position
@onready var material = meshInstance.material_override

func _ready():
	updateMesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update or lastpos != global_position:
		update = false
		lastpos = global_position
		updateMesh()
		
		var uvOffset = Vector3(global_position.x/xSize * material.uv1_scale.x, global_position.z/zSize * material.uv1_scale.y, 0)
		material.uv1_offset = uvOffset

func updateMesh():
	var arrayMesh : ArrayMesh
	var surfTool = SurfaceTool.new()
	
	var n = FastNoiseLite.new()
	n.noise_type=FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.1
	
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x + global_position.x,z + global_position.z) * 5
			
			var uv = Vector2.ZERO
			uv.x = inverse_lerp(0, xSize, x)
			uv.y = inverse_lerp(0, zSize, z)
			surfTool.set_uv(uv)
			
			surfTool.add_vertex(Vector3(float(x)-float(xSize)/2.0, y, float(z)-float(xSize)/2.0))
	
	var vert = 0
	for z in zSize:
		for x in xSize:
			surfTool.add_index(vert)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+1+xSize)
			
			surfTool.add_index(vert+1+xSize)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+2+xSize)
			vert += 1
		vert += 1

	surfTool.generate_normals()
	arrayMesh = surfTool.commit()
	
	meshInstance.mesh = arrayMesh
