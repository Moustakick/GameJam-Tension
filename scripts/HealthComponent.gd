extends Node2D

class_name HealthComponent

@export var health = 10
@onready var blood = preload("res://scene/blood.tscn")

func _ready():
	pass

func take_damage(dmg : int):
	health -= dmg
	print("Took damage :", dmg )
	if health<0:
		var bld = blood.instantiate()
		get_parent().get_parent().add_child(bld)
		get_parent().queue_free()
