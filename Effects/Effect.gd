extends AnimatedSprite

#onready var animateSprite = $AnimatedSprite

func _ready():
	self.connect("animation_finished",self,"_on_animation_finished")
	frame = 0
	play("Animate")
#	animateSprite.frame = 0
#	animateSprite.play("Animate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_animation_finished():
	queue_free()
