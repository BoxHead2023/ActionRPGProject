extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

#export(bool) var show_hit = true
#func _on_Hurtbox_area_entered(area):
#	if show_hit:
#		var effect = HitEffect.instance()
#		#Here parent will free
#		#Dont use parent of parent
#		var main = get_tree().current_scene
#		main.add_child(effect)
#		effect.global_position = global_position

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func creat_hit_effect():
	
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false

#After Godot V.3.4 monitorable has not function well, need to change to monitoring
func _on_Hurtbox_invincibility_started():
	#set_deferred("monitoring", false)
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
	#monitoring = true
	collisionShape.disabled = false
