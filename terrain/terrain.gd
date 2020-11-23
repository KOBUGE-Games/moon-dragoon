extends RigidBody2D


export var length = 1024
export var speed = 500


func _ready():
	linear_velocity = Vector2(-speed, 0)


# make the tiles move and delete if out of screen + invoke new tile creation
func _physics_process(_delta):
	if get_global_position().x < -length:
		# Defer call as we can't add children during _integrate_forces.
		# It's better to defer here than in the actual method to ensure proper
		# position of the terrain instance.
		get_parent().call_deferred("create_terrain")
		queue_free()
