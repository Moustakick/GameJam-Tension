class_name AnchorCamera2D
extends Camera2D

# Distance to the target in pixels below which the camera slows down.
const SLOW_RADIUS := 300.0

# Maximum speed in pixels per second.
@export var max_speed := 2000.0
# Mass to slow down the camera's movement
@export var mass := 2.0

@export var player_zoom = 3.0

var _velocity = Vector2.ZERO
# Global position of an anchor area. If it's equal to `Vector2.ZERO`,
# the camera doesn't have an anchor point and follows its owner.
var _anchor_position := Vector2.ZERO
var last_position := Vector2.ZERO
var _target_zoom := 3.0

# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SWAY_SPEED: float = 1.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var NOISE_SHAKE_STRENGTH: float = 20.0
@export var NOISE_SWAY_STRENGTH: float = 10.0
# The starting range of possible offsets using random values
@export var RANDOM_SHAKE_STRENGTH: float = 30.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 10.0

enum ShakeType {
	Random,
	Noise,
	Sway
}

@onready var random_shake = $ui/button_container/random_shake
@onready var noise_shake = $ui/button_container/noise_shake
@onready var noise_sway = $ui/button_container/noise_sway

@onready var noise = FastNoiseLite.new()
# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
@onready var rand = RandomNumberGenerator.new()
var shake_type: int = ShakeType.Random
var shake_strength: float = 0.0


func _ready() -> void:
	# Setting a node as top-level makes it move independently of its parent.
	top_level = true
	rand.randomize()
	
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2


# Every frame, we update the camera's zoom level and position.
func _physics_process(delta: float) -> void:
	update_zoom()

	# The camera's target position can either be `_anchor_position` if the value isn't
	# `Vector2.ZERO` or the owner's position. The owner is the root node of the scene in which we
	# instanced and saved the camera. In our demo, it's the Player.
	var pos
	if is_instance_valid(owner):
		pos = owner.global_position
	else:
		pos = global_position
	
	var target_position: Vector2 = (
		pos
		if _anchor_position.is_equal_approx(Vector2.ZERO)
		else _anchor_position
	)

	arrive_to(target_position)

func detach_camera():
	_anchor_position = Vector2.ZERO
	_target_zoom = player_zoom

# Entering in an `Anchor2D` we receive the anchor object and change our `_anchor_position` and
# `_target_zoom`
func _on_AnchorDetector2D_anchor_detected(anchor: Anchor2D) -> void:
	_anchor_position = anchor.global_position
	_target_zoom = anchor.zoom_level


# Leaving the anchor the zoom return to 1.0 and the camera's center to the player
func _on_AnchorDetector2D_anchor_detached() -> void:
	_anchor_position = Vector2.ZERO
	_target_zoom = player_zoom

# Smoothly update the zoom level using a linear interpolation.
func update_zoom() -> void:
	if not is_equal_approx(zoom.x, _target_zoom):
		# The weight we use considers the delta value to make the animation frame-rate independent.
		var new_zoom_level: float = lerp(
			zoom.x, _target_zoom, 1.0 - pow(0.008, get_physics_process_delta_time())
		)
		zoom = Vector2(new_zoom_level, new_zoom_level)


# Gradually steers the camera to the `target_position` using the arrive steering behavior.
func arrive_to(target_position: Vector2) -> void:
	var distance_to_target := position.distance_to(target_position)
	# We approach the `target_position` at maximum speed, taking the zoom into account, until we
	# get close to the target point.
	var desired_velocity := (target_position - position).normalized() * max_speed * zoom.x
	# If we're close enough to the target, we gradually slow down the camera.
	if distance_to_target < SLOW_RADIUS * zoom.x:
		desired_velocity *= (distance_to_target / (SLOW_RADIUS * zoom.x))

	_velocity += (desired_velocity - _velocity) / mass
	position += _velocity * get_physics_process_delta_time()

# -*--------------------------------------

func apply_random_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH
	shake_type = ShakeType.Random
	
func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH
	shake_type = ShakeType.Noise
	
func apply_noise_sway() -> void:
	shake_type = ShakeType.Sway
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		print("shaky")
		apply_noise_shake()
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, float(0), float(SHAKE_DECAY_RATE * delta))
	
	var shake_offset: Vector2
	
	match shake_type:
		ShakeType.Random:
			shake_offset = get_random_offset()
		ShakeType.Noise:
			shake_offset = get_noise_offset(delta, NOISE_SHAKE_SPEED, shake_strength)
		ShakeType.Sway:
			shake_offset = get_noise_offset(delta, NOISE_SWAY_SPEED, NOISE_SWAY_STRENGTH)
	
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = shake_offset

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)
