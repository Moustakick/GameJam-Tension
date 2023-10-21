class_name Player
extends CharacterBody2D

var FRICTION = 0.4
var SPEED = 100.0

@onready var health = $HealthComponent as HealthComponent
@onready var sword = preload("res://scene/sword.tscn")
@onready var center_marker_key = $CenterMarkerKey
@onready var sword_marker_key = $CenterMarkerKey/SwordMarkerKey
@onready var center_marker_mouse = $CenterMarkerMouse
@onready var sword_marker_mouse = $CenterMarkerMouse/SwordMarkerMouse
@onready var anchor_camera = $AnchorCamera2D
@onready var death_timer = $DeathTimer
@onready var timer_label = $AnchorCamera2D/TimerLabel

var sw
var is_sw_key = false
var is_sw_mouse = false
var direction
var last_rotation = 0
var first_movement = false
var time_left = 0

func _ready():
	time_left = death_timer.wait_time
	var mils = fmod(time_left,1)*100
	var secs = fmod(time_left,60)
	
	var count_down = "%01d.%02d" % [secs, mils]
	timer_label.text = count_down

func get_movement_input():
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()


	var mouse_pos = get_viewport().get_mouse_position()
	var global_pos = get_global_transform_with_canvas().get_origin()
	
	# update sword position key
	if direction == Vector2(0,0):
		center_marker_key.rotation = last_rotation
	else:
		center_marker_key.rotation = 0
		center_marker_key.rotate(direction.angle())
		last_rotation = center_marker_key.rotation
	
	# update sword position key
	var mouse_direction = mouse_pos - global_pos
	center_marker_mouse.rotation = 0
	center_marker_mouse.rotate(mouse_direction.angle())
	
	# Smooth steering
	var target_velocity = direction * SPEED
	velocity += (target_velocity - velocity) * FRICTION
	move_and_slide()
	
	# First movement
	if  first_movement == false and velocity != Vector2(0,0):
		first_movement = true
		anchor_camera.detach_camera()
		death_timer.start()

func _input(event):
	# attack with key board
	if not is_sw_mouse:
		if event.is_action_pressed("attack_key"):
			is_sw_key = true
			sw = sword.instantiate()
			sword_marker_key.add_child(sw)
		if is_sw_key and event.is_action_released("attack_key"):
			sw.queue_free()
			is_sw_key = false
	
	# attack with mouse
	if not is_sw_key:
		if event.is_action_pressed("attack_mouse"):
			is_sw_mouse = true
			sw = sword.instantiate()
			sword_marker_mouse.add_child(sw)
		if is_sw_mouse and event.is_action_released("attack_mouse"):
			sw.queue_free()
			is_sw_mouse = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	get_movement_input()
	
	if not death_timer.is_stopped():
		time_left -= delta
		if time_left < 0.001:
			time_left = 0
			anchor_camera.reparent(get_parent())
			health.take_damage(100)
			
		var mils = fmod(time_left,1)*100
		var secs = fmod(time_left,60)
		
		var count_down = "%01d.%02d" % [secs, mils]
		
		timer_label.text = count_down
		

func _on_hurtbox_body_entered(body):
	print(1)
	health.take_damage(1)
	pass # Replace with function body.

func _on_hurtbox_area_entered(area):
	print(1)
	health.take_damage(1)
	pass # Replace with function body.

func _on_timer_timeout():
	print("Boum")
	pass # Replace with function body.
