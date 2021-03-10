extends MeshInstance

export(Resource) var settings = preload("res://settings/DefaultSettings.tres")
export(float) var line_width := 2.0

func _ready() -> void:
	update_color()

func setup_with_plane_size(size: Vector2) -> void:
	var half_size = size * 0.5
	var inner_x = half_size.x
	var outer_x = half_size.x + line_width
	var inner_y = half_size.y
	var outer_y = half_size.y + line_width
	
	var vertices = PoolVector3Array()
	vertices.append(Vector3(-outer_x, 0, -outer_y))
	vertices.append(Vector3(-inner_x, 0, -inner_y))
	
	vertices.append(Vector3(outer_x, 0, -outer_y))
	vertices.append(Vector3(inner_x, 0, -inner_y))
	
	vertices.append(Vector3(outer_x, 0, outer_y))
	vertices.append(Vector3(inner_x, 0, inner_y))
	
	vertices.append(Vector3(-outer_x, 0, outer_y))
	vertices.append(Vector3(-inner_x, 0, inner_y))
	
	vertices.append(Vector3(-outer_x, 0, -outer_y))
	vertices.append(Vector3(-inner_x, 0, -inner_y))
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)

func update_color() -> void:
	material_override.albedo_color = settings.background_color.inverted()