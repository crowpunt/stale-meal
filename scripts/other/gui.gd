extends CanvasLayer


@onready var selecting: StaticBody2D = $Selecting
@onready var color_rect: ColorRect = $ColorRect

var mouse_in: Array = [false, false, false, false]

var move_select_towards: bool = true


func _process(_delta: float) -> void:
	handle_upgrading()
	handle_shading_rect()


func _physics_process(_delta: float) -> void:
	handle_movement()


func handle_shading_rect() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if UpgradeInfo.selected_app != -1:
		color_rect.modulate = Color(1, 1, 1, 0.8)
	else:
		color_rect.modulate = Color(1, 1, 1, 0)
		


func handle_movement() -> void:
	if UpgradeInfo.selected_app > -1:
		move_select_towards = false
	else:
		move_select_towards = true
	
	if move_select_towards == true:
		if selecting.position.x > -40:
			selecting.position.x -= 4
	else:
		if selecting.position.x < 0:
			selecting.position.x += 4


func handle_upgrading() -> void:
	var save_spot: int = Save.save_data["cell_ids"][UpgradeInfo.selected_app]
	var cat: int = int(str(save_spot)[0])
	var type: int
	
	if save_spot != 0:
		type = int(str(save_spot)[1])
	else:
		type = 0
	
	if Input.is_action_just_pressed("left_click") and UpgradeInfo.selected_app > -1:
		if mouse_in[0] == true:
			if cat != 1:
				cat = 1
				type = 1
			elif type < 5:
				type += 1
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[1] == true:
			if cat != 2:
				cat = 2
				type = 1
			elif type < 3:
				type += 1
			print(str(UpgradeInfo.selected_app) + " id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[2] == true:
			if cat != 3:
				cat = 3
				type = 1
			elif type < 3:
				type += 1
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[3] == true:
			cat = 0
			type = 0
			print(str(UpgradeInfo.selected_app) + " made blank")
		
		print("closed menu for appliance " + str(UpgradeInfo.selected_app))
		save_spot = int((cat * 10) + type)
		Save.save_data["cell_ids"][UpgradeInfo.selected_app] = save_spot
		UpgradeInfo.selected_app = -1
		Save.save_to_file()


# im calling this the signal yard because that sounds cool

func _on_oven_button_mouse_entered() -> void:
	mouse_in[0] = true


func _on_oven_button_mouse_exited() -> void:
	mouse_in[0] = false


func _on_register_button_mouse_entered() -> void:
	mouse_in[1] = true


func _on_register_button_mouse_exited() -> void:
	mouse_in[1] = false


func _on_table_button_mouse_entered() -> void:
	mouse_in[2] = true


func _on_table_button_mouse_exited() -> void:
	mouse_in[2] = false


func _on_remove_button_mouse_entered() -> void:
	mouse_in[3] = true


func _on_remove_button_mouse_exited() -> void:
	mouse_in[3] = false
