@tool

extends Button3D

func press() -> void:
	print("start")

func setup_button() -> void:
	button_pressed.connect(press)
