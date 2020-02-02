extends BaseBuildings

func interact():
	player.change_shield(100 - player.shield_buff_time)
