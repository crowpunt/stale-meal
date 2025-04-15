extends ColorRect


var alpha: float = 1
var alpha_time: float = 0.3


func _ready() -> void:
	self.visible = true


func _process(delta: float) -> void:
	alpha_time -= delta
	if alpha_time <= 0:
		alpha -= 0.25
		self.modulate = Color(1, 1, 1, alpha)
		alpha_time = 0.3

	if alpha <= 0:
		queue_free()
		print("fully faded rect")
