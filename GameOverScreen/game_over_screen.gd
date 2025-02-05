extends Control


func _ready() -> void:
	$VBoxContainer/RichTextLabel.visible_ratio = 0
	$VBoxContainer/again.visible = false
	
	Engine.time_scale = 1.0

func _process(delta: float) -> void:
	$VBoxContainer/RichTextLabel.visible_ratio += delta / 1.5
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("click"):
		$VBoxContainer/RichTextLabel.visible_ratio = 1
	
	if $VBoxContainer/RichTextLabel.visible_ratio >= 1:
		$VBoxContainer/again.visible = true
	

@export_file("*.tscn") var first_area : String

func _on_again_pressed() -> void:
	get_tree().change_scene_to_file(first_area)
