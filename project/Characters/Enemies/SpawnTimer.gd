extends Timer

const MONSTER_SCENE = preload("res://Characters/Enemies/Alien.tscn")

var monsters_to_spawn
var controller

func _on_SpawnTimer_timeout():
	var monster = MONSTER_SCENE.instance()
	monster.position = get_parent().position
	announce_new_enemy(monster)
	get_parent().get_parent().add_child(monster)

	monsters_to_spawn -= 1
	if (monsters_to_spawn == 0):
		self.queue_free()

func announce_new_enemy(en):
	controller.assert_new_enemy(en)
