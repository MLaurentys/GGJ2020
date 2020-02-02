extends Button

func _on_Retry_pressed() -> void:
	$Effect.play()
	var tree = self.get_tree()
	tree.change_scene("res://Game.tscn")
