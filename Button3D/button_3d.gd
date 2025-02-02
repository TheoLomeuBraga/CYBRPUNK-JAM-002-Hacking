@tool

extends Area3D

class_name Button3D

@export var shape : Vector3:
	get():
		return shape
	set(value):
		shape = value
		if $CollisionShape3D != null:
			$CollisionShape3D.shape.size = value

@export var text : String:
	get():
		return text
	set(value):
		text = value
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.text = value

@export var font : Font:
	get():
		return font
	set(value):
		font = value
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.font = value

@export var pixel_size : float = 0.1:
	get():
		return pixel_size
	set(value):
		pixel_size = value
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.pixel_size = value

@export var font_depth : float = 0.1:
	get():
		return font_depth
	set(value):
		font_depth = value
		if $MeshInstance3D != null:
			$MeshInstance3D.mesh.depth = value

signal button_pressed
signal button_released

var mouse_is_above : bool = false

@export var base_material : Material
@export var foucus_material : Material
@export var click_material : Material

func setup_button() -> void:
	pass

func _ready() -> void:
	if not Engine.is_editor_hint():
		$MeshInstance3D.mesh.material = base_material
		setup_button()

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if mouse_is_above:
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
