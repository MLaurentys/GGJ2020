extends CanvasLayer

var buildings
var current_enemies
var player

#loaded once
func load_player(plyer):
	player = plyer
func load_buildings(building_list):
	buildings = building_list

#loaded every physics frame
func load_enemies():
	current_enemies = $Enemies.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
