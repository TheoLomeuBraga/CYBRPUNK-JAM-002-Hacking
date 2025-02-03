@tool
extends CharacterBody3D
class_name Enemy


@export var base_material : Material :
	get():
		return base_material
	set(value):
		base_material = value
		if $template_psx_charter/Object/Skeleton3D != null:
			for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
				for c2 in c1.get_children():
					if c2 is MeshInstance3D:
						c2.mesh.set("surface_0/material",value)

@export var outline_material : Material :
	get():
		return outline_material
	set(value):
		outline_material = value
		if $template_psx_charter/Object/Skeleton3D != null:
			for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
				for c2 in c1.get_children():
					if c2 is MeshInstance3D:
						c2.mesh.set("surface_1/material",value)

@export var walk_animation_speed : float : 
	get():
		if $template_psx_charter/AnimationTree != null:
			return $template_psx_charter/AnimationTree.get("parameters/walk/blend_position")
		return 0
	set(value):
		if $template_psx_charter/AnimationTree != null:
			$template_psx_charter/AnimationTree.set("parameters/walk/blend_position",value)

func shot() -> void:
	$template_psx_charter/AnimationTree.set("parameters/OneShot/request","fire")

func _ready() -> void:
	if not Engine.is_editor_hint():
		pass

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		velocity = Vector3.ZERO
		
		move_and_slide()
