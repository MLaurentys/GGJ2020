extends Node2D

export(float) var cooldown := 0.2
var player

func init(plyer):
	player = plyer
	
func _ready() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	var area2D : Area2D = $Area2D
	var overlapping_areas = area2D.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("enemy"):
			area.get_parent().receive_damage(player.player_damage, self, player.get_node("Sprite").last_attack)
	
	yield(get_tree().create_timer(cooldown), "timeout")
	player.attacking = false
	queue_free()
