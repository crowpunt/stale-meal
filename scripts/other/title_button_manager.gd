extends CanvasLayer


var file_path: String = "user://stalemeal.save"
@onready var load_button: Button = $LoadButton
@onready var save_guard: Button = $SaveGuard
@onready var save_button: Button = $SaveButton


func _process(_delta: float) -> void:
	if save_guard.disabled == false:
		save_button.disabled = true
		save_guard.position.x = save_button.position.x
	else:
		save_button.disabled = false
		save_guard.position.x = 120


func _on_save_pressed() -> void:
	print("save button pressed")
	Save.save_data = Save.save_data_temp
	Save.save_to_file()
	save_guard.disabled = false


func _on_load_pressed() -> void:
	print("load button pressed")
	# load is already ran at the start during the migration process
	pass


func _on_save_guard_pressed() -> void:
	print("save guard pressed")
	save_guard.disabled = true
