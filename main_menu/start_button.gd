@tool

extends Button3D

@export var start_sceane : PackedScene
func press() -> void:
	get_tree().change_scene_to_packed(start_sceane)

func setup_button() -> void:
	button_pressed.connect(press)
