class_name Player
extends CharacterBody2D

var FRICTION = 0.4
var SPEED = 100.0
var DASH_SPEED = 2000.0
var TIMER = 3 #sec

@onready var health = $HealthComponent as HealthComponent
@onready var sword = preload("res://scene/sword.tscn")
@onready var center_marker_key = $CenterMarkerKey
@onready var sword_marker_key = $CenterMarkerKey/SwordMarkerKey
@onready var center_marker_mouse = $CenterMarkerMouse
@onready var sword_marker_mouse = $CenterMarkerMouse/SwordMarkerMouse
@onready var anchor_camera = $AnchorCamera2D
@onready var death_timer = $DeathTimer
@onready var timer_label = $AnchorCamera2D/TimerLabel
@onready var animation_player = $AnimationPlayer
@onready var dash_label = $AnchorCamera2D/DashLabel
@onready var gameover_label = $AnchorCamera2D/GameOverLabel
@onready var victory_label = $AnchorCamera2D/VictoryLabel
@onready var endtimer_label = $AnchorCamera2D/EndTimeLabel

var ennemy_group
var sw
var is_sw_key = false
var is_sw_mouse = false
var direction
var last_rotation = 0
var first_movement = false
var time_left = 0
var dash_cpt = 1
var is_safe = false
var timer=0;
var end=false

func _ready():
	gameover_label.visible=false
	victory_label.visible=false
	endtimer_label.visible=false
	end=false
	death_timer.wait_time = TIMER
	time_left = death_timer.wait_time
	var mils = fmod(time_left,1)*100
	var secs = fmod(time_left,60)
	
	timer_label.add_theme_color_override("font_color", Color(1,1,1))
	timer_label.text = "%01d.%02d" % [secs, mils]
	
	dash_label.text = "dash : %01d" % [dash_cpt]
	dash_label.visible = false
	
	var level = get_parent()
	var safe_zones = get_tree().get_nodes_in_group("safe_zone")
	if safe_zones.has(level):
		is_safe = true
		timer_label.visible = false

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
		animation_player.play("idle")
	else:
		center_marker_key.rotation = 0
		center_marker_key.rotate(direction.angle())
		last_rotation = center_marker_key.rotation
		animation_player.play("move")
	
	# update sword position key
	var mouse_direction = mouse_pos - global_pos
	center_marker_mouse.rotation = 0
	center_marker_mouse.rotate(mouse_direction.angle())
	
	# Smooth steering
	var target_velocity = direction * SPEED
	velocity += (target_velocity - velocity) * FRICTION
	move_and_slide()
	
	# First movement
	if  !first_movement and velocity != Vector2(0,0):
		first_movement = true
		anchor_camera.detach_camera()
		dash_label.visible = true
		
		if !is_safe:
			death_timer.start()

func dash():
	var global_pos = get_global_transform_with_canvas().get_origin()
	var mouse_pos=get_viewport().get_mouse_position()
	var mouse_direction= mouse_pos - global_pos
	mouse_direction=mouse_direction.normalized()
	if dash_cpt>0:
		velocity = Vector2(mouse_direction) * DASH_SPEED
		dash_cpt -= 1
		dash_label.text = "dash : %01d" % [dash_cpt]
		if dash_cpt<1:
			dash_label.add_theme_color_override("font_color", Color(1,0,0))
		else:
			dash_label.add_theme_color_override("font_color", Color(1,1,1))

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
	
	# dash
	if event.is_action_pressed("dash"):
		dash()

func _physics_process(delta):
	timer+=delta
	ennemy_group=get_tree().get_nodes_in_group("enemy")
	get_movement_input()
	if(ennemy_group.size()==0 && end==false):
		end=true
		death_timer.stop()
		victory_label.visible=true
		endtimer_label.visible=true
		var mils = fmod(timer,1)*100
		var secs = fmod(timer,60)
		endtimer_label.text = "in %01d.%02ds" % [secs, mils]
		
	
	if not death_timer.is_stopped():
		time_left -= delta
		
		if time_left < 0.001:
			time_left = 0
		
		var mils = fmod(time_left,1)*100
		var secs = fmod(time_left,60)
		timer_label.text = "%01d.%02d" % [secs, mils]
		
		var new_color = lerp(Color(0,0,0), Color(1,1,1), secs/TIMER)
		timer_label.add_theme_color_override("font_color", new_color)

func _on_hurtbox_body_entered(body):
	print(1)
	health.take_damage(1)

func _on_hurtbox_area_entered(area):
	print(1)
	health.take_damage(1)

func _on_timer_timeout():
	anchor_camera.reparent(get_parent())
	gameover_label.visible=true
	timer_label.add_theme_color_override("font_color", Color(1,0,0))
	health.take_damage(100)

func enemy_died():
	if !is_safe:
		time_left = TIMER # reset
		death_timer.stop()
		death_timer.start(time_left)
		
	anchor_camera.apply_noise_shake()
	
	if dash_cpt<3:
		dash_cpt += 1
		dash_label.text = "dash : %01d" % [dash_cpt]
		dash_label.add_theme_color_override("font_color", Color(1,1,1))
	elif dash_cpt==3:
		dash_label.add_theme_color_override("font_color", Color(1,0,0))
