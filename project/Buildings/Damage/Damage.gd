extends BaseBuildings

func interact():
	player.change_attack(100 - player.attack_buff_time)
