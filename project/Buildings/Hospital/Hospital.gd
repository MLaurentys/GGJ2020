extends BaseBuildings

func _ready():
	pass 

func interact():
	player.change_health(-1)
	pass
