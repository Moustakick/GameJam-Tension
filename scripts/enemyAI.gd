extends Node2D

@onready var enemy_detection_zone = $EnemyDetectionZone
@onready var escape_timer = $EscapeTimer
@onready var move_timer = $RandomMoveTimer

# states
enum State {
	WALK_ARROUND,
	ESCAPE,
	PANIC
}

var state = State.WALK_ARROUND
var enemy: Enemy = null
var player: Player = null
var direction: Vector2
var is_walking = true
var random = RandomNumberGenerator.new()

func set_state(new_state):
	if new_state != state:
		state = new_state
		
		if new_state == State.PANIC:
			enemy.speed = enemy.PANIC_SPEED
		else:
			enemy.speed = enemy.NORMAL_SPEED

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_parent()
	move_timer.start()
	_on_random_move_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		State.WALK_ARROUND:
			if is_walking:
				enemy.velocity = direction * enemy.speed
				enemy.move_and_slide()
			else:
				enemy.velocity = Vector2(0,0)
			pass
		State.ESCAPE:
			enemy.velocity = direction * enemy.speed
			enemy.move_and_slide()
			pass
		State.PANIC:
			if player != null:
				direction = (enemy.position - player.position).normalized()
				enemy.velocity = direction * enemy.speed
				enemy.move_and_slide()
			pass

func _on_enemy_detection_zone_body_entered(body: Node):
	if body.is_in_group("player"):
		set_state(State.PANIC)
		player = body

func _on_enemy_detection_zone_body_exited(body):
	if player != null and body == player:
		set_state(State.ESCAPE)
		player = null
		escape_timer.start()

func _on_escape_timer_timeout():
	if state == State.ESCAPE:
		set_state(State.WALK_ARROUND)

func _on_random_move_timer_timeout():
	if state == State.WALK_ARROUND:
		is_walking = !is_walking
		if is_walking:
			var dir_angle = random.randf_range(-PI, PI)
			direction = Vector2(1, 0).rotated(dir_angle)
