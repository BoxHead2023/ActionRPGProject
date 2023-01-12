extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var hearthUIFull = $HeartUIFull
onready var hearthUIEmpty = $HeartUIEmpty
#onready var label = $Label

func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	if hearthUIFull != null:
		hearthUIFull.rect_size.x = hearts * 15

#	if label != null:
#		label.text = "HP = " + str(hearts)

func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts,max_hearts)
	if hearthUIEmpty != null:
		hearthUIEmpty.rect_size.x = hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_hearts")
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")
