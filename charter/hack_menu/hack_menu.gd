extends Control

func has_button_foucus() -> bool:
	for c in $VBoxContainer/HBoxContainer/VBoxContainer.get_children():
		if c.has_focus():
			return true
	return false

func grab_foucus_first_button() -> void:
	for c in $VBoxContainer/HBoxContainer/VBoxContainer.get_children():
		c.grab_focus()
		break

func _ready() -> void:
	grab_foucus_first_button()

func _process(delta: float) -> void:
	if not has_button_foucus():
		grab_foucus_first_button()
