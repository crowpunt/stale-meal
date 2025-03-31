class_name zoom_camera_comp
extends Node


@onready var parent: Camera2D = get_parent()


func _process(_delta: float) -> void:
	zoom_camera(parent)


func zoom_camera(camera: Camera2D) -> void:
	if Input.is_action_just_released("zoom_in"):
		print("camera zooming in")
		if camera.zoom.x < 1:
			camera.zoom.x += 0.05
			camera.zoom.y += 0.05
	if Input.is_action_just_released("zoom_out"):
		print("camera zooming out")
		if camera.zoom.x > 0.35:
			camera.zoom.x -= 0.05
			camera.zoom.y -= 0.05
