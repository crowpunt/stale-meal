class_name autoplay_comp
extends Node


@onready var parent: AnimatedSprite2D = get_parent()


func _ready() -> void:
	parent.play("default")
		# only autoplays default, sorry!
