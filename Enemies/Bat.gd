extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_RANGE = 4

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
#	print(stats.max_health)
#	print(stats.health)
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1, 3))
				update_wander()
			
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1, 3))
				update_wander()
				
			#var direction = global_position.direction_to(wanderController.target_position)
			#velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			#sprite.flip_h = velocity.x < 0
			accelerate_towards_point(wanderController.target_position,delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_RANGE:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1, 3))
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				#var direction = (player.global_position - global_position).normalized()
				#var direction = global_position.direction_to(player.global_position)
				#velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				accelerate_towards_point(player.global_position,delta)
			else:
				state = IDLE
			#sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	#pick random one state:
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.creat_hit_effect()
	hurtbox.start_invincibility(0.4)
	
#	if stats.health <= 0:
#		queue_free()
#	print(stats.health)

# Call down in the scene tree(Bat to Stats), 
#signal up in the scene tree(Stats to Bat).

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")