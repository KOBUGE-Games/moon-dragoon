extends RigidBody2D

# make the tiles move and delete if out of screen + invoke new tile creation
func _integrate_forces(state):
	state.set_linear_velocity(Vector2(global.speed_x,0))
	if get_global_position().x < -global.length:
		get_parent().create_terrain()
		queue_free()
	pass
