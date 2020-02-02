extends YSort

func _ready():
	$Minimap.load_player($Player)
	$Minimap.load_wave_controller($WaveController)
	var t : Rect2 = $TileMap.get_used_rect()
	global.spawn_area[2] =t.size.x * 32
	global.spawn_area[3] =t.size.y * 32
	if not global.play_tutorial:
		$Insight.scale = Vector2(0,0)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_minimap"):
		if $Minimap.scale == Vector2(0,0):
			$Minimap.scale = Vector2(1,1)
		else:
			$Minimap.scale = Vector2(0,0)

