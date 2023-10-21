extends Node2D

@onready var enemy_detection_zone = $EnemyDetectionZone
@onready var escape_timer = $EscapeTimer

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

func set_state(new_state):
	if new_state != state:
		state = new_state
		if new_state == State.PANIC:
			enemy.SPEED *= 2
		else:
			enemy.SPEED /= 2
		emit_signal("state_changed", state)

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		State.WALK_ARROUND:
			pass
		State.ESCAPE:
			if player != null:
				enemy.velocity = direction * enemy.SPEED
				enemy.move_and_slide()
			else :
				set_state(State.ESCAPE)
		State.PANIC:
			if player != null:
				direction = (enemy.position - player.position).normalized()
				enemy.velocity = direction * enemy.SPEED
				enemy.move_and_slide()
			else :
				set_state(State.ESCAPE)

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
	set_state(State.WALK_ARROUND)
