extends StaticBody2D


enum State {
	WALKING,
	EATING,
	LEAVING,
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: int = State.WALKING
var current_table: StaticBody2D = null
var speed: float = randf_range(0.25, 1)
var recheck_cooldown: float = 0.5


func _ready() -> void:
	randomize()
	sprite.animation = str(randi_range(1, 6))
	
	current_table = get_nearest_table()
	if current_table and state == State.WALKING:
		current_table.taken = true
	add_to_group("customers")
	print("customer created")


func _process(delta: float) -> void:
	recheck_cooldown -= delta
	
	if recheck_cooldown <= 0 or current_table == null:
		if current_table == null:
			current_table = get_nearest_table()
		if current_table != null and current_table.taken == false:
			current_table.taken = true
		recheck_cooldown = 0.5
	
	if state == State.EATING:
		Save.save_data["happy"] -= 0.5 * delta
		sprite.pause()
		sprite.frame = 0
	else:
		sprite.play()


func _physics_process(_delta: float) -> void:
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
			var exit_pos: Vector2 = get_parent().global_position
			global_position = global_position.move_toward(exit_pos, speed)
			
			if global_position.distance_to(exit_pos) < 5:
				print("customer exited the building")
				current_table.taken = false
				remove_from_group("customers")
				queue_free()



func get_nearest_table() -> StaticBody2D:
	var closest: StaticBody2D = null
	for appliance: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
		if str(appliance.type)[0] == "3" and appliance.taken == false:
				closest = appliance
				break
	return closest
