extends Node2D

class_name HealthComponent

@onready var blood_particle = preload("res://scene/blood_particles.tscn")
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
		blood_spray()
		level.remove_child(character)
		character.call_deferred("free")
		var blood = BLOOD.instantiate()
		blood.position = character.position
		level.add_child(blood)
		
func blood_spray():
	var blood_instance = blood_particle.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	var player = get_tree().get_nodes_in_group("player")[0]
	blood_instance.spread = 360
	blood_instance.amount = 100
