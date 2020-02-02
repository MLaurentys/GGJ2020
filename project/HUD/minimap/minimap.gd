extends CanvasLayer

onready var buildings = []
onready var current_enemies = []
var player
var wave_controller
#loaded once
func load_player(plyer):
	var pp = $PinGenerator.create_pin("player", plyer)
	pp.name = "Player"
	player = pp
	add_child(pp)
func load_wave_controller(controller):
	wave_controller = controller
func load_buildings(building_list):
	buildings = building_list

#loaded every physics frame
func load_enemies():
	current_enemies = $Enemies.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var newer = wave_controller.get_new_enemies()
	for en in newer:
		$Enemies.add_child($PinGenerator.create_pin("enemy", en))
	for b in buildings:
		b.update_state()
	player.update_state()
	for e in current_enemies:
		e.update_state()
