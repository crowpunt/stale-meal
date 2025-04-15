extends StaticBody2D


var in_area: bool = false


func _process(delta: float) -> void:
	if in_area == true and Input.is_action_just_pressed("left_click"):
		print("mess destroyed")
		self.queue_free()
	
	Save.save_data["happy"] -= 1 * delta



func _on_area_2d_mouse_entered() -> void:
	in_area = true


func _on_area_2d_mouse_exited() -> void:
	in_area = false
