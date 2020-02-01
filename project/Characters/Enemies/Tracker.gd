extends Node

export(float) var amplitude = 0
export(float) var period = 0.3

onready var locator = Locator.new(get_tree())

var running = false
var direction := Vector2()
var deviation := 0.0

func _ready():
	$Timer.wait_time = self.period
	$Timer.start()

func is_within_range(enemy) -> bool:
	var player = self.locator.find_entity("player")
	if player == null:
		return false
	var player_position = player.position
	var enemy_position = enemy.position
	var enemy_min_range = enemy.min_attack_range
	var enemy_max_range = enemy.max_attack_range
	self.direction = player_position - enemy_position
	
	self.running = false
	if self.direction.length() > enemy_max_range:
		return false
	elif self.direction.length() < enemy_min_range:
		self.running = true
		return false
	
	return true

func track() -> Vector2:
	var dir_sign = 1
	if self.running: dir_sign = -1;
	return dir_sign * self.direction.normalized().rotated(self.deviation / 360.0 * 2 * PI)

func _deviate():
	self.deviation = (1 - 2*randf()) * self.amplitude
