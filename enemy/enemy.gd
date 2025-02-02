@tool
extends CharacterBody3D
class_name Enemy


@export var base_material : Material :
	get():
		return base_material
	set(value):
		base_material = value
		for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
			for c2 in c1.get_children():
				if c2 is MeshInstance3D:
					c2.mesh.set("surface_0/material",value)

@export var outline_material : Material :
	get():
		return outline_material
	set(value):
		outline_material = value
		for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
			for c2 in c1.get_children():
				if c2 is MeshInstance3D:
					c2.mesh.set("surface_1/material",value)

func _ready() -> void:
	if not Engine.is_editor_hint():
		pass

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		velocity = Vector3.ZERO
		
		move_and_slide()
