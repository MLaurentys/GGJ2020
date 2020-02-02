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
	print(t)
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("toggle_minimap"):
		if $Minimap.scale == Vector2(0,0):
			$Minimap.scale = Vector2(1,1)
		else:
			$Minimap.scale = Vector2(0,0)
