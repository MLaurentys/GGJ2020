extends Pin

var check = true
func set_pos():
	var posi = ref_object.position
	pos = [posi.x/(global.spawn_area[2] - global.spawn_area[0]),
			 posi.y/(global.spawn_area[3] - global.spawn_area[1])]
	set_disp_pos()
	
	
func update_state():
	if check:
		var hp = ref_object.health
		if hp < 30:
			$Working.visible = false
			$Low_Life.visible = true
			if hp == 0:
				check = false
			
		else:
			$Working.visible = true
			$Low_Life.visible = false
	
