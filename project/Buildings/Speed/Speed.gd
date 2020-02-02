extends BaseBuildings

func interact():
	player.change_energy(100 - player.move_spd_buff_time)
