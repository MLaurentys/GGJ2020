extends Pin

onready var already_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_state():
	var posi = ref_object.position
	pos = [posi.x/(global.spawn_area[2] - global.spawn_area[0]),
			 posi.y/(global.spawn_area[3] - global.spawn_area[1])]
