extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/levels/level_test.tscn")
	print("pressed")


func _on_area_2d_area_entered(area):
	print("Aïe")
