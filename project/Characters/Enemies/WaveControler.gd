extends Node

const PORTAL_THRESHOLD = 0.5
const SPAWNER_TIME_BASE = 4
const SPAWNER_MONSTERS_BASE = 2
const SPAWNS_PER_WAVE = [4, 8, 11]
const SPAWNER_SCN = preload("res://Characters/Enemies/Spawner.tscn")

var locator
onready var new_enemies = []
var timer_sequence = [30, 30, 120]
################### voltar pra 10 quando for lançar
var intervals = [10, 25, 10]
var portal_timer = [90, 30]

var check_portal_life = false
var wave_index = 0
var portal
var tileset

onready var toClear = false
func _ready():
	$IntervalTimer.wait_time = intervals[0]
	$PortalTimer.wait_time = portal_timer[0]
	
	$IntervalTimer.start()
	$PortalTimer.start()
	$Interval.play()
	locator = Locator.new(get_tree())
	portal = locator.find_entity("portal")
	tileset = locator.find_entity("tileset")

func _physics_process(_delta):
	if portal.health <= 0:
		toggle_game_over_screen()
		
	if toClear:
		toClear = false
		new_enemies = []
		
	if not check_portal_life:
		return
	
	if portal.health < PORTAL_THRESHOLD*portal.max_health:
		toggle_game_over_screen()
	
func toggle_game_over_screen():
	var gameover = locator.find_entity('gameover')
	var sepia = locator.find_entity('sepia')
	gameover.show()
	sepia.show()
	gameover.get_node("DefeatFanfare").play()
	get_tree().paused = true
	
func get_new_enemies():
	var ne = new_enemies
	if(new_enemies.size() > 0):
		toClear = true
	return ne

func assert_new_enemy(ene):
	new_enemies.append(ene)

func create_new_wave():
	var spawners_spawned = 0
	var lim_x = int(global.spawn_area[2])
	var lim_y = int(global.spawn_area[3])
	
	while(spawners_spawned < SPAWNS_PER_WAVE[wave_index]):
		var x = randi() % lim_x
		var y = randi() % lim_y
		
		var xt = x/32 - 18
		var yt = y/32 - 26
		var tile_index = tileset.get_cell(xt, yt)
		
		if tile_index == 2:
			continue
			
		var sp = SPAWNER_SCN.instance()
		sp.get_node("SpawnTimer").wait_time = SPAWNER_TIME_BASE - randi() % 2 - wave_index
		
		sp.get_node("SpawnTimer").monsters_to_spawn = SPAWNER_MONSTERS_BASE + randi() % 2 + wave_index
		
		sp.get_node("SpawnTimer").controller = self
		
		sp.position = Vector2(x, y)
		add_child(sp)
		spawners_spawned += 1
	
func _on_IntervalTimer_timeout():
	$WaveTimer.wait_time = timer_sequence[wave_index]
	create_new_wave()
	
	wave_index += 1
	$WaveTimer.start()
	
	$Interval.stop()
	$WaveActive.play()

func _on_WaveTimer_timeout():
	$IntervalTimer.wait_time = intervals[wave_index]
	$IntervalTimer.start()
	$WaveActive.stop()
	$Interval.play()

func _on_PortalTimer_timeout():
	if check_portal_life:
		#TODO: you win
		pass
	
	$PortalTimer.wait_time = portal_timer[1]
	check_portal_life = true
	#Feedback pro usuario pra indicar que ele tem 30s pras pessoas evacuarem
	$PortalTimer.start()
	
	pass # Replace with function body.

func _on_HealthyWarningTimer_timeout():
	#Feedback de informar ao usuario que tem que manter o portal healthy
	pass # Replace with function body.
