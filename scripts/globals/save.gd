extends Node


var file_path: String = "user://stalemeal.save"
const VERSION: String = "v3-playtest"


var save_data_temp: Dictionary = {
	"version" : VERSION,
	"cell_ids" : [
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
	],
	"money" : 2000,
	"happy" : 100,
	"tutorial_done" : false,
}

var save_data: Dictionary


func _ready() -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if FileAccess.file_exists(file_path) == false or file.get_as_text().strip_edges() == "":
		save_data = save_data_temp
		save_to_file()
	
	save_data = load_data()
	save_data["version"] = VERSION
	
	@warning_ignore("untyped_declaration")
	for data in save_data_temp:
		if not save_data.has(data):
			save_data[data] = save_data_temp[data]
	save_to_file()


func save_to_file() -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string: String = JSON.stringify(save_data)
	file.store_string(json_string)
	print("saved")


func load_data() -> Dictionary:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	print("loaded save")
	return JSON.parse_string(file.get_as_text())
