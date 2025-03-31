extends StaticBody2D


@onready var place: int = int(self.name)
@onready var type: int = int(Save.save_data["cell_ids"][place])

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var in_area: bool = false


func _process(_delta: float) -> void:
	change_type()
	# keeping this for now for later behaviors
	#if floor(type / 10) == 1:
		#stuff
	select_app()


func change_type() -> void:
	type = int(Save.save_data["cell_ids"][place])
	sprite.animation = str(type)


func select_app() -> void:
	if in_area == true:
		if Input.is_action_just_pressed("right_click"):
			if UpgradeInfo.selected_app != place:
				UpgradeInfo.selected_app = place
				print("opening menu for appliance " + self.name)
			else:
				UpgradeInfo.selected_app = -1
				print("closing menu for appliance " + self.name)


func _on_area_2d_mouse_entered() -> void:
	in_area = true


func _on_area_2d_mouse_exited() -> void:
	in_area = false
