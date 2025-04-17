extends Node


@onready var label: Label = $Label

var customer_scene: PackedScene = preload("res://scenes/units/customer.tscn")
var enemy_scene: PackedScene = preload("res://scenes/units/angry.tscn")

var progress: int = 0
var text: Array = [
	"welcome, [LMB] to continue",
	"[RMB] the top-left most square and [LMB] the seat icon",
	"[RMB] on the square next to it and [LMB] the fire icon",
	"when the customer arrives, [LMB] on the oven to serve it", #spawn customer here
	"when the customer arrives, [LMB] on the oven to serve it",
	"the customer left a mess, [LMB] on it to clean",
	"click on the angry customer with [LMB]",
	"click on the angry customer with [LMB]", #spawn enemy here
	"happiness decreases for messes, unserved customers, and attacked customers. [LMB] to continue",
	"to upgrade the chair, [RMB] it and [LMB] the seat icon again",
	"you can upgrade everything 3 times. Upgrade the stove with the fire icon",
	"the cash icon spawns cash registers, which multiplies cash gain. [LMB] to continue",
	"scroll up/down to zoom in/out. [LMB] to finish tutorial"
]


func _ready() -> void:
	Save.save_data["money"] = 100000


func _process(_delta: float) -> void:
	if progress >= 13:
		Save.save_data = Save.save_data_temp
		Save.save_data["tutorial_done"] = true
		get_tree().change_scene_to_file("res://scenes/main_scenes/game.tscn")
	else:
		label.text = text[progress]
	
	if progress == 3:
		progress += 1
		add_child(customer_scene.instantiate())
	elif progress == 6:
		progress += 1
		add_child(enemy_scene.instantiate())
	
	if Input.is_action_just_pressed("left_click"):
		progress += 1
