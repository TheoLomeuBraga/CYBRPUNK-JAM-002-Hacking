extends Node3D

var closed : bool = true

@export var mat : Material

func _ready() -> void:
	$"../MeshInstance3D2".mesh.material = mat

func hack(hack_name : String) -> void:
	
	if closed and hack_name == "open":
		$"../../AnimationPlayer".play("open")
		
		var color : Color = mat.get("emission")
		color.r = 0.0
		color.g = 1.0
		mat.set("emission",color)
		
		$"../../GPUParticles3D".emitting = true
		$"../../AudioStreamPlayer3D".play()
		
		closed = false

@export var hacks : Array[Hack]


func get_hack_list() -> Array[Hack]:
	return hacks

var progress : float = 0
