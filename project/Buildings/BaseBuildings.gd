extends StaticBody2D
class_name BaseBuildings

export (int) var max_health: int = 100
var health: int 
onready var locator = Locator.new(get_tree())
onready var player = locator.find_entity("player")

func _ready():
	self.health = max_health
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
		$FixArea.remove_from_group("fixarea")
		$Sprite.frame = 2
		$InteractionArea.queue_free()
		$FixArea.queue_free()
		$CollisionShape2D.queue_free()
		$ProgressBar.queue_free()
		$Destroy.play()
		return
	health -= dmg
	if health < max_health/2:
		$Sprite.frame = 1
	$ProgressBar.setHealth()
	
func interact():
	pass
