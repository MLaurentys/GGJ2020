extends Button

func _on_Quit_pressed():
	$Effect.play()
	get_tree().quit()
