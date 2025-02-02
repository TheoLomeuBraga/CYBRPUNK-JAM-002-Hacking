extends Button3D
class_name TestButton

func enter() -> void:
	print("enter")

func exit() -> void:
	print("exit")

func press() -> void:
	print("press")

func release() -> void:
	print("release")

func _ready() -> void:
	mouse_entered.connect(enter)
	mouse_exited.connect(exit)
	
	button_pressed.connect(press)
	button_released.connect(release)
