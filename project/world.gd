extends YSort

var locator
func _ready():
	locator = Locator.new(get_tree())
	
	var t : Rect2 = $TileMap.get_used_rect()
	global.spawn_area[2] =t.size.x * 32
	global.spawn_area[3] =t.size.y * 32
	var builds = get_tree().get_nodes_in_group("buildings")
	$Minimap.load_player($Player)
	$Minimap.load_wave_controller($WaveController)
	$Minimap.load_buildings(builds)

	if not global.play_tutorial:
		$Insight.scale = Vector2(0,0)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_minimap"):
		if $Minimap.scale == Vector2(0.0001,0.0001):
			$Minimap.scale = Vector2(1,1)
		else:
			$Minimap.scale = Vector2(0.0001,0.0001)



func _on_Completion_timeout():
	get_tree().pause()
	pass # Replace with function body.
	
func toggle_win_screen():
	var youwin = locator.find_entity('youwin')
	youwin.show()
	youwin.get_node("WinFanfare").play()
	get_tree().paused = true
	
func _on_Timer_timeout():
	toggle_win_screen()
