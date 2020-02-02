extends Node2D
class_name Pin

var ref_object
var pos #(0->100, 0->100) [%]
onready var disp_pos = [0,0]

func update_state():
	pass
	
func set_obj(obj):
	ref_object = obj

func set_disp_pos():
	disp_pos[0] = pos.x * global.minimap_area[2]
	disp_pos[1] = pos.y * global.minimap_area[3]
	position = disp_pos
