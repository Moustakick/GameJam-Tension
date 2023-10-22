extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scene/levels/menu_principal.tscn")
	elif !is_instance_valid(player):
		if event is InputEventKey or event is InputEventMouseButton:
			get_tree().reload_current_scene()
