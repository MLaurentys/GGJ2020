extends Button

func _on_Credits_pressed() -> void:
	$Effect.play()
	var error_flag = self.get_tree().change_scene("res://CreditsMenu.tscn")
