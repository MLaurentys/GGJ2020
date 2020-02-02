extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Minimap.load_player($Player)
	$Minimap.load_wave_controller($WaveController)
	var t : Rect2 = $TileMap.get_used_rect()
	global.spawn_area[2] =t.size.x * 32
	global.spawn_area[3] =t.size.y * 32
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
