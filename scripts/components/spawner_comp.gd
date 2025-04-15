class_name customer_spawner
extends Node


var cooldown: float = 3
var cooldown_enemy: float = 1
var customer_scene: PackedScene = preload("res://scenes/units/customer.tscn")
var enemy_scene: PackedScene = preload("res://scenes/units/angry.tscn")


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	cooldown -= delta
	cooldown_enemy -= delta
	
	if cooldown_enemy <= 0:
		var happy: int = Save.save_data["happy"]
		if randi_range(1, happy) == 1:
			print("enemy spawned")
			get_parent().add_child(enemy_scene.instantiate())
		else:
			print("enemy was not spawned")
		cooldown_enemy = 1
	
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
			cooldown = randf_range(1, 3)
			print("no more tables for customers to spawn at")
			print("new cooldown at " + str(cooldown))
