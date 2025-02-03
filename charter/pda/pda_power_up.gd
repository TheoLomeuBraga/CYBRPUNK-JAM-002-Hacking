extends Node3D

func _physics_process(delta: float) -> void:
	rotate_y(delta * 2)
	if $ShapeCast3D.is_colliding():
		for i : int in $ShapeCast3D.get_collision_count():
			var n : Node = $ShapeCast3D.get_collider(i)
			if n is NetGuner:
				n.game_mode = 1
				
				$ShapeCast3D.enabled = false
				$gun_model.visible = false
				$PdaPowerUp.visible = false
				$AudioStreamPlayer3D.play()
				break



func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
