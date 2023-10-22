extends HealthComponent

func take_damage(dmg : int):
	health -= dmg
	print("Took damage :", dmg )
	if health<=0:
		blood_spray()
		get_tree().call_group("player", "enemy_died")
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
	blood_instance.rotation = global_position.angle_to_point(player.global_position) + PI
