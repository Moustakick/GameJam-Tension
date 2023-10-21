extends Node2D

@onready var enemy_detection_zone = $EnemyDetectionZone

# states
enum {
	WALK_ARROUND,
	ESCAPE,
	PANIC,
	ATTACK
}

var state = WALK_ARROUND

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_detection_zone_body_entered(body):
	pass # Replace with function body.
