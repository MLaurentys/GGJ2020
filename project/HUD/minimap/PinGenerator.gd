extends Node
const enemy_pin = preload("res://HUD/minimap/pins/EnemyPin.tscn")
const player_pin = preload("res://HUD/minimap/pins/PlayerPin.tscn")
const building_pin = preload("res://HUD/minimap/pins/BuildingPin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_pin(type, obj):
	var np
	if(type == "enemy"):
		np = enemy_pin.instance()
	elif (type == "player"):
		np = player_pin.instance()
	else:
		np = building_pin.instance()
	np.set_obj(obj)
	return np
