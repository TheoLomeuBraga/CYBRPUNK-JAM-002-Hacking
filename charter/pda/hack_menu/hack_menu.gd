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

signal hack

func call_hack(hack_name: String) -> void:
	hack.emit(hack_name)

func clear_hack_buttons() -> void:
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/noHackWarning.visible = true
	
	for c in $VBoxContainer/HBoxContainer/VBoxContainer.get_children():
		$VBoxContainer/HBoxContainer/VBoxContainer.remove_child(c)
		c.queue_free()

@export var font : Font
func add_hack_button(name : String,title : String,color : Color) -> void:
	$VBoxContainer/HBoxContainer.visible = true
	$VBoxContainer/noHackWarning.visible = false
	
	var new_button : HackButton = HackButton.new()
	
	new_button.hack_name = name
	new_button.text = title
	new_button.add_theme_color_override("font_color",color)
	new_button.add_theme_color_override("font_hover_color",color)
	new_button.add_theme_font_override("font",font)
	
	$VBoxContainer/HBoxContainer/VBoxContainer.add_child(new_button)
	new_button.hack.connect(call_hack)

func connect_hacks() -> void:
	for c in $VBoxContainer/HBoxContainer/VBoxContainer.get_children():
		c.hack.connect(call_hack)

func _ready() -> void:
	
	clear_hack_buttons()
	
	#add_hack_button("hack_1","hack 1",Color.RED)
	#add_hack_button("hack_2","hack 2",Color.GREEN)
	#add_hack_button("hack_3","hack 3",Color.BLUE)

func _process(delta: float) -> void:
	if not has_button_foucus():
		grab_foucus_first_button()
