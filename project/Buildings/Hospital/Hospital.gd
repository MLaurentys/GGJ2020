extends BaseBuildings

func interact():
	player.change_health(player.max_health - player.health)
