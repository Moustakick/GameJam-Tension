extends Node2D

class_name HealthComponent

@onready var blood_particle = preload("res://scene/blood_particles.tscn")
@export var BLOOD = preload("res://scene/blood.tscn")
@export var health = 1
var camera = null
var character
var level

func _ready():
	character = get_parent()
	level = character.get_parent()
	
	if character is Player:
		camera = $"../AnchorCamera2D"

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
	if camera != null:
		camera.NOISE_SHAKE_STRENGTH = 40
		camera.SHAKE_DECAY_RATE = 3
		camera.apply_noise_shake()
	var blood_instance = blood_particle.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	var player = get_tree().get_nodes_in_group("player")[0]
	blood_instance.spread = 360
	blood_instance.amount = 100
