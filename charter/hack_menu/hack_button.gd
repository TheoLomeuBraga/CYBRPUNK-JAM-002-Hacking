extends Button
class_name HackButton

@export var hack_name : String

signal hack

func hack_pressed() -> void:
	hack.emit(hack_name)

func _ready() -> void:
	pressed.connect(hack_pressed)
