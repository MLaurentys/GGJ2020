extends StaticBody2D
class_name BaseBuildings

export (int) var max_health: int = 100
var health: int 
onready var locator = Locator.new(get_tree())
onready var player = locator.find_entity("player")

func _ready():
	self.health= max_health/2
	$ProgressBar.setHealth()
	
func fix_building():
	if health < max_health:
		health += 1
		$ProgressBar.setHealth()
		return true
	return false
		
func interact():
	print("Interagiu")
	pass
