extends Control

onready var buttonAudioStreamPlayer = $ButtonAudioStreamPlayer

var stats = PlayerStats

func _ready():
	self.visible = false
	stats.connect("no_health",self,"on_no_health")

func on_no_health():
		self.visible = true

func _on_ButtonRestart_pressed():
	get_tree().reload_current_scene()

func _on_ButtonQuit_pressed():
	buttonAudioStreamPlayer.play()
	yield(buttonAudioStreamPlayer, "finished")
	get_tree().quit()
