extends Node2D

#onready var globals = Globals
onready var timer = $Timer

func _ready():
#	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()
#	pass

#func bool_finish():
#	yield(get_tree().create_timer(3), "timeout")
#	connect("timeout", self, "change_scence")

#func change_scence():	
#	get_tree().change_scene("res://MainTitleScreen.tscn")

func _on_Timer_timeout():
	get_tree().change_scene("res://MainTitleScreen.tscn")
