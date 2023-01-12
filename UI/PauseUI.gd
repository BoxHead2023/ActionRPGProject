extends Control

#const PauseSound = preload("res://Music and Sounds/Pause.wav")

onready var pauseAudioStreamPlayer = $PauseAudioStreamPlayer
onready var buttonAudioStreamPlayer = $ButtonAudioStreamPlayer
#onready var blinkAnimationPlayer = $PauseIcon/BlinkAnimationPlayer


func _ready():
	self.visible = false

func pause_game():	
	get_tree().paused = not get_tree().paused
	self.visible = not self.visible
	#var pauseSound = PauseSound.instance()
	

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
		pauseAudioStreamPlayer.play()
	

func _on_ButtonResume_pressed():
	buttonAudioStreamPlayer.play()
	pause_game()

func _on_ButtonQuit_pressed():
	buttonAudioStreamPlayer.play()
	yield(buttonAudioStreamPlayer, "finished")
	get_tree().quit()



