extends CharacterBody2D

class_name Enemy

@onready var health = $HealthComponent as HealthComponent
@onready var ai = $EnemyAI

var NORMAL_SPEED = 15.0
var PANIC_SPEED = 45.0
var speed = NORMAL_SPEED

signal enemy_death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hurtbox_area_entered(hitbox : HitBox):
	health.take_damage(hitbox.get_damage())

func death_signal_activation():
	emit_signal("enemy_death")
