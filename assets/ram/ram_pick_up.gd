extends MeshInstance3D


var used : bool = false
func _physics_process(delta: float) -> void:
	rotation.y += delta * 5
	if not used:
		if $ShapeCast3D.is_colliding():
			for i in $ShapeCast3D.get_collision_count():
				var c : Node3D = $ShapeCast3D.get_collider(i)
				if c is NetGuner:
						c.ram += 2
						used = true
						visible = false
						$Timer.start()
						$AudioStreamPlayer.play()


func _on_timer_timeout() -> void:
	queue_free()
