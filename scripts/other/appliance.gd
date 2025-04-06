extends StaticBody2D


@onready var place: int = int(self.name)
@onready var type: int = int(Save.save_data["cell_ids"][place])

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var selecting: Sprite2D = $Selecting

var in_area: bool = false
var noticed: bool = false


#note that ysort can only be used if the 2 objects being ysorted are direct siblings and their parent has ysort enabled


func _ready() -> void:
	add_to_group("appliances")


func _process(_delta: float) -> void:
	change_type()
	select_app()
	handle_selected()
	# keeping this for now for later behaviors
	#if floor(type / 10) == 1:
		#stuff


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


func handle_selected() -> void:
	if UpgradeInfo.selected_app == place:
		selecting.visible = true
	else:
		selecting.visible = false


func _on_area_2d_mouse_entered() -> void:
	in_area = true


func _on_area_2d_mouse_exited() -> void:
	in_area = false
