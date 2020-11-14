extends RigidBody2D

func _integrate_forces(state):
	state.set_linear_velocity(Vector2(0,0))
	if get_global_position().x < -256:
		queue_free()
	pass
