extends Node2D

class_name Blood

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.modulate = Color(1, 0, 0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
