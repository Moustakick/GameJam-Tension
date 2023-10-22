extends HealthComponent

func take_damage(dmg : int):
	health -= dmg
	print("Took damage :", dmg )
	if health<=0:
		get_tree().call_group("player", "enemy_died")
		level.remove_child(character)
		character.call_deferred("free")
		var blood = BLOOD.instantiate()
		blood.position = character.position
		level.add_child(blood)
