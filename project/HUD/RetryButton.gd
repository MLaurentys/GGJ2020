extends Button

func _on_Retry_pressed() -> void:
	$Effect.play()
	var tree = self.get_tree()
	var error_flag = tree.change_scene("res://Game.tscn")
