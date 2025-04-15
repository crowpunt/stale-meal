extends StaticBody2D


var in_area: bool = false
var nearest: StaticBody2D
var speed: float = randf_range(0.75, 1)
var check_cd: float = 60


func _process(delta: float) -> void:
	check_cd -= delta
	if check_cd <= 0:
		print("enemy checked for customers")
		nearest = get_nearest_customer()
		check_cd = 20
	if in_area == true and Input.is_action_just_pressed("left_click"):
		print("enemy destroyed")
		self.queue_free()


func _physics_process(_delta: float) -> void:
	if nearest != null:
		self.global_position = self.global_position.move_toward(nearest.global_position, speed)


func get_nearest_customer() -> StaticBody2D:
	var closest: StaticBody2D = null
	for customer: StaticBody2D in get_tree().get_nodes_in_group("customers"):
		closest = customer
		break
	return closest


func _on_area_2d_mouse_entered() -> void:
	in_area = true


func _on_area_2d_mouse_exited() -> void:
	in_area = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if nearest != null:
		if area.get_parent() == nearest:
			print("enemy collided with customer")
			area.get_parent().remove_from_group("customers")
			area.get_parent().queue_free()
			nearest = null
			Save.save_data["happy"] -= 30
			check_cd = 3
