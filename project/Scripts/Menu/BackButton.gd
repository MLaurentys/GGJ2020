extends Button

func _on_Back_pressed() -> void:
	$Effect.play()
	var error_flag = self.get_tree().change_scene("res://MainMenu.tscn")

