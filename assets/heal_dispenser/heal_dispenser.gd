extends StaticBody3D

func hack(hack_name : String) -> void:
	
	if hack_name == "heal":
		if Global.player != null:
			$GPUParticles3D.emitting = true
			$heal_model.visible = false
			$AudioStreamPlayer3D.play()
			Global.player.health += 50
		

@export var hacks : Array[Hack]


func get_hack_list() -> Array[Hack]:
	if $heal_model.visible:
		return hacks
	else:
		return []

func _physics_process(delta: float) -> void:
	$heal_model.rotation.y += delta * 5
