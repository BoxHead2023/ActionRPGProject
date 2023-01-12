extends Node2D

# This is mainly about hot wo instance the scene inside the script

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
		
	# Step 1: store the load the scene (with first letter capitalized, 
	# such as G of GrassEffect) in var
	# var GrassEffect = load("res://Effects/GrassEffect.tscn")
	
	# Step 2: store scene.instance() in var
	var grassEffect = GrassEffect.instance()
	
	# Step 3: access the scence which have the child you want to load
	#var world = get_tree().current_scene
	#world.add_child(grassEffect)
	get_parent().add_child(grassEffect)
	
	# Step 4: set the position generally 
	grassEffect.global_position = global_position
	
func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
