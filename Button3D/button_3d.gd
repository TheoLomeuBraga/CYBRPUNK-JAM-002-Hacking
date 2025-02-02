@tool

extends Area3D

class_name Button3D

@export var shape : Vector3:
	get():
		if $CollisionShape3D != null:
			return $CollisionShape3D.shape.size
		return Vector3.ZERO
	set(value):
		if $CollisionShape3D != null:
			$CollisionShape3D.shape.size = value

@export var text : String:
	get():
		if $MeshInstance3D != null:
			return $MeshInstance3D.mesh.text
		return ""
	set(value):
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.text = value

@export var font : Font:
	get():
		if $MeshInstance3D != null:
			return $MeshInstance3D.mesh.font
		return null
	set(value):
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.font = value

@export var pixel_size : float = 0.1:
	get():
		if $MeshInstance3D != null:
			return $MeshInstance3D.mesh.pixel_size
		return 0
	set(value):
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.pixel_size = value

@export var font_depth : float = 0.1:
	get():
		if $MeshInstance3D != null:
			return $MeshInstance3D.mesh.depth
		return 0
	set(value):
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.depth = value

signal button_pressed
signal button_released

var mouse_is_above : bool = false

@export var base_material : Material
@export var foucus_material : Material
@export var click_material : Material

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("click"):
			button_pressed.emit()
			$MeshInstance3D.mesh.material = click_material
		elif  Input.is_action_just_released("click"):
			button_released.emit()
			$MeshInstance3D.mesh.material = foucus_material


func _on_mouse_entered() -> void:
	mouse_is_above = true
	$MeshInstance3D.mesh.material = foucus_material


func _on_mouse_exited() -> void:
	mouse_is_above = false
	$MeshInstance3D.mesh.material = base_material
