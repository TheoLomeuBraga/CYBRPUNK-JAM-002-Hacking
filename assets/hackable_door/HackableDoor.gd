extends Node3D

func hack(hack_name : String) -> void:
	if hack_name == "open":
		$"../../AnimationPlayer".play("open")

@export var hacks : Array[Hack]
func get_hack_list() -> Array[Hack]:
	return hacks
