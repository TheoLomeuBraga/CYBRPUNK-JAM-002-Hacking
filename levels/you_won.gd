extends Node3D




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is NetGuner:
		$MeshInstance3D/GPUParticles3D.emitting = true
		$MeshInstance3D/AudioStreamPlayer3D.play()
		
		$MeshInstance3D2/GPUParticles3D.emitting = true
		$MeshInstance3D2/AudioStreamPlayer3D.play()
