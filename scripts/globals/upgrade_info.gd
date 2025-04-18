extends Node


var selected_app: int = -1


func _process(_delta: float) -> void:
	if Save.save_data["happy"] < 0:
		Save.save_data["happy"] = 0
	elif Save.save_data["happy"] > 100:
		Save.save_data["happy"] = 100
