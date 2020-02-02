extends Pin

onready var already_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_state():
	if(already_dead):
		pass
	if(ref_object == null or ref_object.toDel == true):
		ref_object.queue_free()
		queue_free()
		pass	
	var posi = ref_object.position
	pos = [posi.x/(global.spawn_area[2] - global.spawn_area[0]),
			 posi.y/(global.spawn_area[3] - global.spawn_area[1])]
	set_disp_pos()
