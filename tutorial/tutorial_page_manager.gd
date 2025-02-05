extends Control

@export var pages : Array[Control]

@export var current_page : int = 0:
	get():
		return current_page
	set(value):
		current_page = value
		if value > 0 and value < pages.size() and pages[value] != null:
			for i in pages.size():
				pages[i].visible = i == value
					

func _ready() -> void:
	current_page = current_page
