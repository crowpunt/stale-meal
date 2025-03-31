extends CanvasLayer


@onready var selecting: StaticBody2D = $Selecting

var mouse_in: Array = [false, false, false, false]

var move_select_towards: bool = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click") and UpgradeInfo.selected_app > -1:
		if mouse_in[0] == true:
			Save.save_data["cell_ids"][UpgradeInfo.selected_app] = 11
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[1] == true:
			Save.save_data["cell_ids"][UpgradeInfo.selected_app] = 21
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[2] == true:
			Save.save_data["cell_ids"][UpgradeInfo.selected_app] = 31
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[3] == true:
			Save.save_data["cell_ids"][UpgradeInfo.selected_app] = 0
			print(str(UpgradeInfo.selected_app) + " made blank")
		
		print("closed menu for appliance " + str(UpgradeInfo.selected_app))
		UpgradeInfo.selected_app = -1
		Save.save_to_file()
	
	
	if UpgradeInfo.selected_app > -1:
		move_select_towards = false
	else:
		move_select_towards = true
	
	if move_select_towards == true:
		if selecting.position.x > -40:
			selecting.position.x -= 1
	else:
		if selecting.position.x < 0:
			selecting.position.x += 1


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
