extends StaticBody2D


var seated: bool = false
var eating_cd: float = 0
var eating: bool = true
	# going to seat

var recheck_cooldown: float = 0.5
var nearest: StaticBody2D
var checks_til_debug: int = 4


func _ready() -> void:
	nearest = get_nearest_table()
	add_to_group("customers")
	print("customer created")


func _process(delta: float) -> void:
	recheck_cooldown -= delta

	if checks_til_debug <= 0:
		checks_til_debug = 4
		if nearest != null:
			print("closest table was " + nearest.name)
		else:
			print("no tables found")
	
	if recheck_cooldown <= 0:
		nearest = get_nearest_table()
		checks_til_debug -= 1
		recheck_cooldown = 0.5


func _physics_process(_delta: float) -> void:
	if seated == true and eating == true:
		Save.save_data["happy"] -= 0.025
	
	if nearest != null:
		var goto_pos: Vector2 = Vector2(nearest.global_position.x, nearest.global_position.y - 3)
		
		if eating == true and seated == false:
			self.global_position = self.global_position.move_toward(goto_pos, 0.5)
		if eating == false and seated == false:
			self.global_position = self.global_position.move_toward(get_parent().position, 0.5)
		
		if self.global_position == get_parent().global_position and seated == false and  eating == false:
			print("customer exited the building")
			queue_free()
		
		if self.global_position == goto_pos and seated == false and eating == true:
			print("customer has reached their table")
			eating = false


func get_nearest_table() -> StaticBody2D:
	var closest: StaticBody2D
	for appliance: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
		if str(appliance.type)[0] == "3":
			closest = appliance
			break
	if closest != null:
		for appliance: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
			if appliance.position.distance_to(self.position) <= closest.position.distance_to(self.position):
				if str(appliance.type)[0] == "3":
					closest = appliance
	return closest
