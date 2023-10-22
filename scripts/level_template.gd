extends Node2D

@onready var player = $Player
@onready var end_screen_timer = $EndScreenTimer

var is_first = true
var screen_lock = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(player) and is_first:
		end_screen_timer.start()
		is_first = false

func _unhandled_input(event):
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	if !screen_lock:
		if event is InputEventKey or event is InputEventMouseButton:
			get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scene/levels/menu_principal.tscn")

func _on_end_screen_timer_timeout():
	screen_lock = false
