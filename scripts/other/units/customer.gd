extends StaticBody2D


enum State {
	WALKING,
	EATING,
	LEAVING,
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var state: int = State.WALKING
var current_table: StaticBody2D = null
var speed: float = randf_range(0.25, 1)
var recheck_cooldown: float = 0.5
var move_cooldown: float = 3
var made_mess: bool = false


func _ready() -> void:
	randomize()
	sprite.animation = str(randi_range(1, 6))
	
	current_table = get_nearest_table()
	if current_table and state == State.WALKING:
		current_table.taken = true
	add_to_group("customers")
	print("customer created")


func _process(delta: float) -> void:
	draw_cooldown_gui()
	
	recheck_cooldown -= delta
	
	if recheck_cooldown <= 0 or current_table == null:
		if current_table == null:
			current_table = get_nearest_table()
		if current_table != null and current_table.taken == false:
			current_table.taken = true
		recheck_cooldown = 0.5
	
	if state == State.EATING:
		Save.save_data["happy"] -= 0.2 * delta
		sprite.pause()
		sprite.frame = 0
	else:
		sprite.play()


func _physics_process(delta: float) -> void:
	#i gotta put this into a function ._.
	match state:
		State.WALKING:
			if current_table:
				var goto_pos: Vector2 = Vector2(current_table.global_position.x, current_table.global_position.y - 3)
				var distance: float = global_position.distance_to(goto_pos)
				
				if distance > 1:  # Stop a few pixels before reaching exact position
					global_position = global_position.move_toward(goto_pos, speed)
				else:
					print("customer has reached their table")
					state = State.EATING
		State.LEAVING:
			if made_mess == false:
				made_mess = true
				var current: int = Save.save_data["cell_ids"][int(current_table.name)]
				if current != 0:
					# this game sucks
					if randi_range(1, int(str(current_table.type)[1]) * 2) == 1 or Save.save_data["tutorial_done"] == false:
						var mess_scene: PackedScene = preload("res://scenes/units/mess.tscn")
						var scene: StaticBody2D = mess_scene.instantiate()
						scene.global_position = self.global_position
						get_tree().get_first_node_in_group("mess_organizer").add_child(scene)
			move_cooldown -= delta
			var exit_pos: Vector2 = get_parent().global_position
			if move_cooldown <= 0:
				global_position = global_position.move_toward(exit_pos, speed)
			
			if global_position.distance_to(exit_pos) < 5:
				current_table.taken = false
				remove_from_group("customers")
				
				var multiplier: float = 1
				for register: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
					if str(register.type)[0] == "2":
						multiplier += (0.25 * (float(str(register.type)[1]) * 1.5))
				Save.save_data["money"] += round(20 * multiplier)
				if Save.save_data["happy"] <= 95:
					Save.save_data["happy"] += 10
				print("customer exited the building, gained " + str(50 * multiplier) + "$")
				Save.save_to_file()
				queue_free()


func draw_cooldown_gui() -> void:
	progress_bar.value = move_cooldown
	if move_cooldown > 0 and state == State.LEAVING:
		progress_bar.visible = true
	else:
		progress_bar.visible = false


func kill() -> void:
	remove_from_group("customers")
	if current_table != null:
		current_table.taken = false
	queue_free()


func get_nearest_table() -> StaticBody2D:
	var closest: StaticBody2D = null
	for appliance: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
		if str(appliance.type)[0] == "3" and appliance.taken == false:
				closest = appliance
				break
	return closest
