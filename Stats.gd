extends Node

#use export(float) to set X.X, if you wanr
export(int) var max_health = 1 setget set_max_health

#health not equal max health until editor onready 
#Solution 2
#change var to onready var
var health = max_health setget set_health

#health not equal max health until editor onready 
#Solution 1 
#var health = max_health
#func _ready():
#	health = max_health

#func _process(delta):
#	if health <= 0 :
#		emit_signal("no_health")

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health,max_health)
	emit_signal("max_health_changed",max_health)

func set_health(value):
	health = value
	emit_signal("health_changed",health)
	if health <= 0 :
		emit_signal("no_health")
		health = max_health
	
func _ready():
	self.health = max_health
