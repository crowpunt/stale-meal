class_name spawner_comp
extends Node


var cooldown: float = randf_range(1, 3)
var customer_scene: PackedScene = preload("res://scenes/units/customer.tscn")


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	cooldown -= delta
	if cooldown <= 0:
		var not_all_taken: bool = false
		for appliance: StaticBody2D in get_tree().get_nodes_in_group("appliances"):
			if str(appliance.type)[0] == "3" and appliance.taken == false:
				not_all_taken = true
		
		if not_all_taken == true:
			cooldown = randf_range(1, 3)
			print("new cooldown at " + str(cooldown))
			get_parent().add_child(customer_scene.instantiate())
		else:
			print("no more tables for customers to spawn at")
			print("new cooldown at " + str(cooldown))
			cooldown = randf_range(3, 6)
