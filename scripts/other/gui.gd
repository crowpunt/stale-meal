extends CanvasLayer


@onready var selecting: StaticBody2D = $Selecting
@onready var color_rect: ColorRect = $ColorRect

@onready var cash_label: Label = $TextGui/CashLabel
@onready var percent_label: Label = $TextGui/PercentLabel
@onready var click_sfx: AudioStreamPlayer = $ClickSFX
@onready var title_track: AudioStreamPlayer = $TitleTrack

var mouse_in: Array = [false, false, false, false]
var move_select_towards: bool = true


func _process(_delta: float) -> void:
	if title_track.playing == false:
		title_track.play()
	
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
		click_sfx.play()
	
	handle_upgrading()
	change_stat_label()
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
		if selecting.position.y < 0:
			selecting.position.y += 4
	else:
		if selecting.position.y > -26:
			selecting.position.y -= 4


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
			if cat != 1 and Save.save_data["money"] >= 300:
				Save.save_data["money"] -= 300
				cat = 1
				type = 1
			elif type < 3 and Save.save_data["money"] >= 500:
				Save.save_data["money"] -= 500
				type += 1
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[1] == true:
			if cat != 2 and Save.save_data["money"] >= 300:
				Save.save_data["money"] -= 300
				cat = 2
				type = 1
			elif type < 3 and Save.save_data["money"] >= 500:
				Save.save_data["money"] -= 500
				type += 1
			print(str(UpgradeInfo.selected_app) + " id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		elif mouse_in[2] == true:
			if cat != 3 and Save.save_data["money"] >= 300:
				Save.save_data["money"] -= 300
				cat = 3
				type = 1
			elif type < 3 and Save.save_data["money"] >= 500:
				Save.save_data["money"] -= 500
				type += 1
			print(str(UpgradeInfo.selected_app) + "s id changed to " + str(Save.save_data["cell_ids"][UpgradeInfo.selected_app]))
		if mouse_in[3] == true:
			if save_spot != 0:
				Save.save_data["money"] += 200
				cat = 0
				type = 0
			print(str(UpgradeInfo.selected_app) + " made blank")
		
		print("closed menu for appliance " + str(UpgradeInfo.selected_app))
		save_spot = int((cat * 10) + type)
		Save.save_data["cell_ids"][UpgradeInfo.selected_app] = save_spot
		UpgradeInfo.selected_app = -1
		Save.save_to_file()


func change_stat_label() -> void:
	var cash: int = int(Save.save_data["money"])
	var percent: int = int(Save.save_data["happy"])
	
	if cash < 9999:
		cash_label.text = str(cash) + "$"
	elif cash < 0:
		cash_label.text = "0$"
	else:
		cash_label.text = "+9999$"
	
	if percent >= 0:
		percent_label.text = "%" + str(percent)
	else:
		percent_label.text = "%0"


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
