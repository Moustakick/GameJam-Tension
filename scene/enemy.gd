extends RigidBody2D

@onready var health = $HealthComponent as HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hurtbox_area_entered(hitbox : HitBox):
	health.take_damage(hitbox.get_damage())
