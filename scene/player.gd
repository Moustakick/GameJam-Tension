extends CharacterBody2D

@export var SPEED = 300.0

@onready var health = $HealthComponent as HealthComponent
@onready var sword = preload("res://scene/sword.tscn")
@onready var center_marker = $CenterMarker
@onready var sword_marker = $CenterMarker/SwordMarker

var sw;
var direction;
var last_rotation = 0;

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if(direction == Vector2(0,0)):
		center_marker.rotation = last_rotation
	else:
		center_marker.rotation = 0
		center_marker.rotate(direction.angle())
		last_rotation = center_marker.rotation
		print(center_marker.rotation)
	
	
	#print(direction)
	velocity = direction * SPEED

func vector_to_rotation(vector : Vector2):
	return vector.angle() * 180/PI

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("attack"):
		sw = sword.instantiate()
		sword_marker.add_child(sw)
	if event.is_action_released("attack"):
		sw.queue_free()

func _physics_process(delta):
	get_input()
	move_and_slide()

func _on_hurtbox_body_entered(body):
	print(1)
	health.take_damage(1)
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	print(1)
	health.take_damage(1)
	pass # Replace with function body.
