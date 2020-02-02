extends Node

const PORTAL_THRESHOLD = 0.5
const SPAWNER_TIME_BASE = 5
const SPAWNER_MONSTERS_BASE = 3
const SPAWNS_PER_WAVE = [10, 20, 30]
const SPAWNER_SCN = preload("res://Characters/Enemies/Spawner.tscn")

onready var new_enemies = []
var timer_sequence = [20, 20, 120]
###################
var intervals = [1, 10, 10]
var portal_timer = [90, 30]

var check_portal_life = false
var wave_index = 0
var portal
var tileset

func _ready():
	$IntervalTimer.wait_time = intervals[0]
	$PortalTimer.wait_time = portal_timer[0]
	
	
	$IntervalTimer.start()
	$PortalTimer.start()
	
	var locator = Locator.new(get_tree())
	portal = locator.find_entity("portal")
	tileset = locator.find_entity("tileset")

func _process(delta):
	if not check_portal_life:
		pass
	
	if portal.health < PORTAL_THRESHOLD*portal.max_health:
		#TODO: game over
		pass
	
func get_new_enemies():
	var ne = new_enemies
	new_enemies.clear()
	return ne

func create_new_wave():
	var spawners_spawned = 0
	var lim_x = int(global.spawn_area[2]/32)
	var lim_y = int(global.spawn_area[3]/32)
	
	while(spawners_spawned < SPAWNS_PER_WAVE[wave_index]):
		var x = randi() % lim_x
		var y = randi() % lim_y
		
		var tile_index = tileset.get_cell(x, y)
		
		if tile_index == 2:
			continue
			
		var sp = SPAWNER_SCN.instance()
		sp.get_node("SpawnTimer").wait_time = SPAWNER_TIME_BASE - randi() % 2 - wave_index
		
		sp.get_node("SpawnTimer").monsters_to_spawn = SPAWNER_MONSTERS_BASE + randi() % 2 + wave_index
		
		add_child(sp)
		spawners_spawned += 1
	
func _on_IntervalTimer_timeout():
	print("lul")
	$WaveTimer.wait_time = timer_sequence[wave_index]
	create_new_wave()
	
	wave_index += 1
	$WaveTimer.start()

func _on_WaveTimer_timeout():
	$IntervalTimer.wait_time = intervals[wave_index]
	$IntervalTimer.start()


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
