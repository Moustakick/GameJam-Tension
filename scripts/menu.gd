extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_menu_enemy_level_1_enemy_death():
	get_tree().change_scene_to_file("res://scene/levels/level_1.tscn")

func _on_menu_enemy_level_2_enemy_death():
	get_tree().change_scene_to_file("res://scene/levels/level_2.tscn")

func _on_menu_enemy_level_3_enemy_death():
	get_tree().change_scene_to_file("res://scene/levels/level_3.tscn")
