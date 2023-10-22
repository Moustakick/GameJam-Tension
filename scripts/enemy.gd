extends CharacterBody2D

class_name Enemy

@onready var health = $HealthComponent as HealthComponent
@onready var ai = $EnemyAI
@onready var animation_player = $AnimationPlayer
@onready var debut_sprite = $DebutSpriteEnemy

var NORMAL_SPEED = 15.0
var PANIC_SPEED = 45.0
var speed = NORMAL_SPEED
var party_has_begin = false
var timer = 0
var sin_amp = 0.4
var sin_freq = 10

signal enemy_death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(animation_player):
		if velocity != Vector2(0,0):
			animation_player.play("move")
		else: 
			animation_player.play("idle")
	
	if !party_has_begin:
		timer+=delta
		
		if is_instance_valid(debut_sprite):
			debut_sprite.move_local_x(sin_amp * sin(timer * sin_freq), true)
			debut_sprite.modulate = Color(1, 0, 0);

func _on_hurtbox_area_entered(hitbox : HitBox):
	health.take_damage(hitbox.get_damage())

func death_signal_activation():
	emit_signal("enemy_death")

func party_begin():
	print("bonjour")
	party_has_begin = true
	debut_sprite.visible = false
