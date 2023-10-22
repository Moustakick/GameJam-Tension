extends CharacterBody2D

class_name Enemy

@onready var health = $HealthComponent as HealthComponent
@onready var ai = $EnemyAI
@onready var animation_player = $AnimationPlayer

var NORMAL_SPEED = 15.0
var PANIC_SPEED = 45.0
var speed = NORMAL_SPEED

signal enemy_death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(animation_player):
		print(velocity)
		if velocity != Vector2(0,0):
			animation_player.play("move")
		else: 
			animation_player.play("idle")
	pass

func _on_hurtbox_area_entered(hitbox : HitBox):
	health.take_damage(hitbox.get_damage())

func death_signal_activation():
	emit_signal("enemy_death")
