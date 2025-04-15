extends StaticBody2D


@onready var place: int = int(self.name)
@onready var type: int = int(Save.save_data["cell_ids"][place])

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var selecting: Sprite2D = $Selecting
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var taken: bool = false
var interact_cooldown: float = 0
var max_cd: int = 10

var in_area: bool = false


#note that ysort can only be used if the 2 objects being ysorted are direct siblings and their parent has ysort enabled


func _ready() -> void:
	add_to_group("appliances")


func _process(delta: float) -> void:
	interact_cooldown -= delta
	
	draw_cooldown_gui()
	manage_type()
	select_app()
	handle_selected()


func manage_type() -> void:
	type = int(Save.save_data["cell_ids"][place])
	sprite.animation = str(type)
	
	if str(type)[0] == "1":
		var style: int = int(str(type)[1])
		max_cd = 4 + (3 - style) * 3
	
	if in_area == true and Input.is_action_just_pressed("left_click") and str(type)[0] == "1" and interact_cooldown <= 0:
		print("stove interacted with, cd is " + str(max_cd))
		for customer: StaticBody2D in get_tree().get_nodes_in_group("customers"):
			if customer.state == customer.State.EATING:
				customer.state = customer.State.LEAVING
				interact_cooldown = max_cd
				break


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


func draw_cooldown_gui() -> void:
	progress_bar.value = interact_cooldown
	progress_bar.max_value = max_cd
	if interact_cooldown > 0:
		progress_bar.visible = true
	else:
		progress_bar.visible = false


func _on_area_2d_mouse_entered() -> void:
	in_area = true


func _on_area_2d_mouse_exited() -> void:
	in_area = false


func get_nearest_table() -> StaticBody2D:
	var closest: StaticBody2D = null
	for customer: StaticBody2D in get_tree().get_nodes_in_group("customers"):
		closest = customer
		break
	return closest
