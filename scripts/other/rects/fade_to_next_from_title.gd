extends ColorRect


var alpha: float = 0
var alpha_time: float = 0.3

var transition: bool = false


func _ready() -> void:
	self.visible = true


func _process(delta: float) -> void:
	if transition == true:
		alpha_time -= delta
		if alpha_time <= 0:
			alpha += 0.25
			self.modulate = Color(1, 1, 1, alpha)
			alpha_time = 0.3

	if alpha >= 1:
		if Save.save_data["tutorial_done"] == true:
			get_tree().change_scene_to_file("res://scenes/main_scenes/game.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/main_scenes/tutorial.tscn")
		print("fully faded rect")


func _on_save_button_pressed() -> void:
	transition = true


func _on_load_button_pressed() -> void:
	transition = true
