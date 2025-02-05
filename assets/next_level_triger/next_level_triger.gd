extends Area3D
class_name NextAreaTriger

@export_file("*.tscn") var next_area : String

func load_next_area(body: Node3D):
	if body is NetGuner:
		get_tree().change_scene_to_file(next_area)


func _ready() -> void:
	body_entered.connect(load_next_area)
