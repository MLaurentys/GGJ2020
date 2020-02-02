extends StaticBody2D
class_name BaseBuildings

export (int) var max_health: int = 100
var health: int 
onready var locator = Locator.new(get_tree())
onready var player = locator.find_entity("player")

func _ready():
	self.health= max_health/2.0
	$ProgressBar.setHealth()
	
func fix_building():
	if health < max_health:
		health += 1
		$ProgressBar.setHealth()
		return true
	return false

func get_attacked(dmg :int):
	if health < dmg:
		health = 0
		#destroy building
	health -= dmg
	$ProgressBar.setHealth()
	
func interact():
	pass
