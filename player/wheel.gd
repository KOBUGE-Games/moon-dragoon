extends RigidBody2D

func _ready():
	set_physics_process(true)


func _physics_process(_delta):
	if $ground_detect.is_colliding() and ($AnimationPlayer.get_current_animation() != "play"):
		$AnimationPlayer.play("rotate")
