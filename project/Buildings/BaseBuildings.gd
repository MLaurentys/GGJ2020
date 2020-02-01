extends StaticBody2D
class_name BaseBuilding

export (int) var max_health: int = 100
var health: int 

func _ready():
	self.health= max_health/2
	$ProgressBar.setHealth()
	
func fix_building():
	if health < max_health:
		health += 1
		$ProgressBar.setHealth()
		
func interact():
	print("Interagiu")
	pass
