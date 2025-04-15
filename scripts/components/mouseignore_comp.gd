class_name mouseignore_comp
extends Node


func _ready() -> void:
	get_parent().mouse_filter = Control.MOUSE_FILTER_IGNORE
