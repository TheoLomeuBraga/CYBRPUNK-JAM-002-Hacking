@tool
extends Node3D

@export var size : Vector2 = Vector2(10.0,10.0) :
	get():
		return size
	set(value):
		size = value
		if $GPUParticles3D != null:
			$GPUParticles3D.process_material.emission_box_extents.x = size.x / 2
			$GPUParticles3D.process_material.emission_box_extents.y = size.y / 2
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.size.x = size.x
			$MeshInstance3D.mesh.size.y = size.y
			$StaticBody3D/CollisionShape3D.shape.size.x = size.x
			$StaticBody3D/CollisionShape3D.shape.size.y = size.y

@export var color : Color = Color.PURPLE :
	get():
		return color
	set(value):
		color = value
		if $GPUParticles3D != null:
			$GPUParticles3D.material_override.emission = color
		if $MeshInstance3D != null:
			var m : StandardMaterial3D = $MeshInstance3D.get_surface_override_material(0)
			m.albedo_color = color
			m.albedo_color.r *= 0.75
			m.albedo_color.g *= 0.75
			m.albedo_color.b *= 0.75
			$MeshInstance3D.set_surface_override_material(0,m)
