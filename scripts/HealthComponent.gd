extends Node2D

class_name HealthComponent

@export var BLOOD = preload("res://scene/blood.tscn")
@export var health = 1
var character
var level

func _ready():
	character = get_parent()
	level = character.get_parent()
	pass

func take_damage(dmg : int):
	health -= dmg
	print("Took damage :", dmg )
	if health<=0:
		level.remove_child(character)
		character.call_deferred("free")
		var blood = BLOOD.instantiate()
		blood.position = character.position
		level.add_child(blood)
