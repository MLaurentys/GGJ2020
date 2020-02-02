extends AudioStreamPlayer2D


func play_sound_once():
	if (!playing):
		play()

