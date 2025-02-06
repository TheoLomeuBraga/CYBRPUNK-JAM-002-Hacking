extends Node3D

var closed : bool = true

@export var mat : Material

func _ready() -> void:
	mat = mat.duplicate()
	$MeshInstance3D/MeshInstance3D2.mesh.material = mat

func open() -> void:
	$AnimationPlayer.play("open")
		
	var color : Color = mat.get("emission")
	color.r = 0.0
	color.g = 1.0
	mat.set("emission",color)
	
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()
	
	closed = false

@export var targets : Array[Node]

func _process(delta: float) -> void:
	var should_open : bool = true
	
	for n in targets:
		if is_instance_valid(n):
			should_open = false
			break
	
	if should_open and closed:
		open()
