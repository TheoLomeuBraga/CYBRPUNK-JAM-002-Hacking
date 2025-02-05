extends StaticBody3D

func hack(hack_name : String) -> void:
	
	if hack_name == "heal":
		if Global.player != null:
			$GPUParticles3D.emitting = true
			#$heal_model.visible = false
			$heal_model.queue_free()
			$AudioStreamPlayer3D.play()
			Global.player.health += 50
		

@export var hacks : Array[Hack]


func get_hack_list() -> Array[Hack]:
	if is_instance_valid($heal_model):
		return hacks
	else:
		return []

func _physics_process(delta: float) -> void:
	if is_instance_valid($heal_model):
		$heal_model.rotation.y += delta * 5
