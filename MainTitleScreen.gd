
extends CanvasLayer

onready var buttonAudioStreamPlayer = $ButtonAudioStreamPlayer

#func button_pressed_sound():
#	audioStreamPlaye.play()

func _on_QuitButton_pressed():
	buttonAudioStreamPlayer.play()
	yield(buttonAudioStreamPlayer, "finished")
	get_tree().quit()
	

func _on_StartButton_pressed():
	buttonAudioStreamPlayer.play()
	get_tree().change_scene("res://Main.tscn")
	
	
