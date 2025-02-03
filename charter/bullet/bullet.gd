extends Node3D

@export var speed : float = 10

func _physics_process(delta: float) -> void:
	
	global_position += -global_basis.z * speed * delta
	
	if $ShapeCast3D.is_colliding():
		for i in  $ShapeCast3D.get_collision_count():
			if $ShapeCast3D.get_collider(i).has_method("get_shot"):
				$ShapeCast3D.get_collider(i).get_shot()
