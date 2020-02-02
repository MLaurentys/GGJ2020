extends Node2D
class_name Pin

var ref_object
var pos #(0->100, 0->100) [%]
var disp_pos

func update_state():
	pass
	
func set_obj(obj):
	ref_object = obj
	disp_pos=[0,0]

func set_disp_pos():
	disp_pos[0] = pos[0] * global.minimap_area[2]
	disp_pos[1] = pos[1] * global.minimap_area[3]
	position.x = disp_pos[0] + 2
	position.y = disp_pos[1] - 2
