class_name derivative_offset_comp
extends Node2D


@onready var parent: Camera2D = get_parent()


func _process(_delta: float) -> void:
	offset_for_pos(get_global_mouse_position())


func offset_for_pos(pos: Vector2) -> void:
	var screen_center: Vector2 = Vector2(60, 48)
	parent.position = screen_center.lerp(pos, 0.15)
