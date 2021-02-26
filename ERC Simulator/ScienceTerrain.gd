extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var chunks = [] # da implementare l'inserimento dei chunk e la liberazione degli oggetti, thread
# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()

func generateFlat(x,y,dim,div): #numeri interi
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()
	for i in range(0,dim):
		for j in range(0,dim):
			var vert = Vector3((x+i)/div,0,(y+j)/div)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(i,j))
			if i > 0 and j > 0:
				indices.append((i-1)*dim+j-1)
				indices.append(i*dim+j-1)
				indices.append(i*dim+j)
				
				indices.append((i-1)*dim+j-1)
				indices.append(i*dim+j)
				indices.append((i-1)*dim+j)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	
func generateTerrain(): #da implementare per un certo chunk
	var mdt = MeshDataTool.new()
	rng.randomize()
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		var my_random_number = rng.randf_range(-5, 5)/100.0
		vertex += Vector3(my_random_number,my_random_number,my_random_number)
		mdt.set_vertex(i, vertex)
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	var col_shape = ConcavePolygonShape.new()
	col_shape.set_faces(mesh.get_faces())
	var collisionShape = CollisionShape.new()
	collisionShape.set_shape(col_shape)
	$StaticBody.add_child(collisionShape)

func calculate(xcalc, x3, x2, x1):
	var res = round(x3*pow(xcalc,3)+x2*pow(xcalc,2)+xcalc*x1)
	return res
	
func matmesh(x, y, value, dim, mdt):
	var vertex = mdt.get_vertex(x*dim+y)
	mdt.set_vertex(x*dim+y, vertex + Vector3(0,value,0))
	
func genCollision():
	var col_shape = ConcavePolygonShape.new()
	col_shape.set_faces(mesh.get_faces())
	var collisionShape = CollisionShape.new()
	collisionShape.set_shape(col_shape)
	#$StaticBody.remove_child(get_node("StaticBody/ColShape")
	$StaticBody.add_child(collisionShape)
	
func gen():
	var accuracy = 400
	var sampledfun = []
	rng.randomize()
	var x3 = rng.randf_range(-100, 100)/50
	var x2 = rng.randf_range(-100, 100)/50
	var x = rng.randf_range(-100, 100)/50
	#print(x3," ",x2," ",x)
	#troviamo la derivata
	var a = 3*x3
	var b = 2*x2
	var c = x
	var delta = (b*b - 4*a*c)
	if delta > 0:
		var firstZero = -b + pow(delta, 0.5)
		var secondZero = -b - pow(delta, 0.5)
		#print(firstZero, secondZero)
		var diff = (firstZero - secondZero)
		var dblock = diff * 1.5
		var start = secondZero - dblock
		var end = firstZero + dblock
		var sampInt = (end - start)/accuracy
		var itervalue = 0
		var maxim = -1000
		var minim = 1000
		while(end - start > itervalue):
			itervalue += sampInt
			var factor = calculate(start+itervalue,x3,x2,x)
			maxim = max(factor,maxim)
			minim = min(factor,minim)
			sampledfun.append(factor)
		for i in range(len(sampledfun)):
			sampledfun[i] -= minim
			sampledfun[i] /= maxim-minim
		var mdt = MeshDataTool.new()
		mdt.create_from_surface(mesh, 0)
		for i in range(accuracy):
			var value = int(sampledfun[i]*accuracy)
			matmesh(i, value, 0.5, accuracy, mdt)
			 
		mesh.surface_remove(0)
		mdt.commit_to_surface(mesh)
	else:
		gen()
	
	
func perlino(dim):
	var perlin_gen = OpenSimplexNoise.new()
	perlin_gen.period = 32
	perlin_gen.persistence = 0.1
	perlin_gen.seed = randi()
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	for i in dim:
		for j in dim:
			matmesh(i, j, perlin_gen.get_noise_2d(i,j), dim, mdt)
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
func _ready():
	generateFlat(-10,-10, 400, 4.0)
	perlino(400)
	genCollision()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
