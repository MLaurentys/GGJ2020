extends Button

func _on_Back_pressed() -> void:
	$Effect.play()
	get_parent().hide()
