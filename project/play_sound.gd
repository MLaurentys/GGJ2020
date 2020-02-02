extends AudioStreamPlayer


func play_sound_once():
	if (!playing):
		play()


func _on_Effect_finished():
	pass # Replace with function body.
