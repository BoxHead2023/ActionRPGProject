extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

#export can be used to test var
export var ACCELERATION = 500
export var MAX_SPEED = 75
export var ROLL_SPEED = 120
export var FRICTION = 500

enum{
	MOVE,
	ROLL,
	ATTACK
	}

# Bigger Project could use more state and node
var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	
	stats.connect("no_health",self,"queue_free")
	
	animationTree.active = true
	
	swordHitbox.knockback_vector = roll_vector

#var animationPlayer = null
#func _ready():
#	animationPlayer = $AnimationPlayer

func _physics_process(delta):
#	Ben video use _process, but velocity = move_and_slide (velocity) suggested 
#	to use in _physics_process within official docs
	
#	match replace
#	if state == MOVE:
#		move_state (delta)
#	elif state == ROLL:
#		pass
#	elif state == ATTACK:
#		attack_state (delta)
	
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)
			

func move_state(delta):
	
	#	if Input.is_action_pressed("ui_right"):
#		velocity.x = 3
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -3
#	elif Input.is_action_pressed("ui_down"):
#		velocity.y = 3
#	elif Input.is_action_pressed("ui_up"):
#		velocity.y = -3
#	else:
#		velocity.x = 0
#		velocity.y = 0
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		
#		if input_vector.x > 0:
#			animationPlayer.play("RunRIght")
#		else:
#			animationPlayer.play("RunLeft")
		
#		velocity += input_vector * ACCELERATION * delta
#		velocity = velocity.clamped (MAX_SPEED * delta)
		velocity = velocity.move_toward (input_vector * MAX_SPEED, ACCELERATION * delta)

	else:
		animationState.travel("Idle")
#		animationPlayer.play("IdleDown")
		velocity = velocity.move_toward (Vector2.ZERO, FRICTION * delta)

# Speed Solution 1: delete the if... else (...* delta) in both sentence
#  const ACCELERATION = 10
#  const MAX_SPEED = 60
#  const FRICTION = 60

# Speed Solution 2: change value of the const to the following value:
#  const ACCELERATION = 500
#  const MAX_SPEED = 80
#  const FRICTION = 500

	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED * 0.75
	animationState.travel("Roll")
	move()
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide (velocity)
	
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.creat_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
