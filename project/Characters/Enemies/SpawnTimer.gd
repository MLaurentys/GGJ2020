extends Timer

const MONSTER_SCENE = preload("res://Characters/Enemies/Alien.tscn")

var monsters_to_spawn

func _on_SpawnTimer_timeout():
	var monster = MONSTER_SCENE.instance()
	monster.position = get_parent().position
	get_parent().get_parent().add_child(monster)

	monsters_to_spawn -= 1
	if (monsters_to_spawn == 0):
		self.queue_free()
