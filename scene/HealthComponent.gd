extends Node2D

class_name HealthComponent

@export var health = 10

func _ready():
	pass
	
func take_damage(dmg : int):
	health -= dmg
	print("Took damage :", dmg )
	if health<0:
		get_parent().queue_free()
