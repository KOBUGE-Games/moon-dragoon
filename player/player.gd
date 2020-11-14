extends RigidBody2D

var speed_y = -500
var speed_x = 500

# gravity scale of the rigid body
const GRAVITY_NORMAL = 10
const GRAVITY_FLY = 5
const MAX_ROTATION = PI/3

# former states
#var button_jump_old = false
#var button_dash_old = false
var contact_count_old

#var jumps_left = 2
var time = 0.0

func _integrate_forces(state):
	
	# input events
	var button_jump = Input.is_action_pressed("ui_up")
	var button_left = Input.is_action_pressed("ui_left")
	var button_right = Input.is_action_pressed("ui_right")
	var contact_count = state.get_contact_count()
	
	var current_velocity = state.get_linear_velocity()
	
	# left and right movement
	if !button_left and !button_right:
		current_velocity.x = 0
#		print("no button")
	elif button_left and button_right:
		current_velocity.x = 0
#		print("2 button")
	elif button_left:
		current_velocity.x = -speed_x
#		print("left")
	elif button_right:
		current_velocity.x = speed_x
#		print("right")
		
	if contact_count == 0:
		print("---")
		print(get_angular_velocity())
		set_angular_velocity(-get_rotation())
		print(get_rotation())
	if abs(get_rotation()) > MAX_ROTATION:
		set_rotation(sign(get_rotation()) * MAX_ROTATION)
#		set_angular_velocity(-sign(get_rotation()) * (MAX_ROTATION - abs(get_rotation())))
#	else:
#		set_angular_velocity(get_angular_velocity())
	
	
	if (contact_count == 1) and (contact_count_old == 0):# and (jumps_left < 2):
#		get_node("fox_body/animation").play("run")
#		jumps_left = 2
		pass
	
#	if button_jump and (button_jump_old == false) and jumps_left: # first jump button press
	if button_jump and (contact_count == 1):
#		get_node("fox_body/animation").play("jump")
		current_velocity.y = speed_y
#		button_jump_old = button_jump
#		jumps_left -= 1
		set_angular_velocity(0)
	elif button_jump and (state.get_contact_count() == 0): # keep jump button pressed
		time += state.get_step()
		current_velocity.y = get_linear_velocity().y
		set_gravity_scale(GRAVITY_FLY)
	else: # no jump pressed
		current_velocity.y = get_linear_velocity().y
		time = 0.0
#		button_jump_old = button_jump
		set_gravity_scale(GRAVITY_NORMAL)
		
	
	# safe former states
#	button_jump_old = button_jump
#	button_dash_old = button_dash
	contact_count_old = contact_count
	
#	current_velocity.x = -get_global_position().x * 100
	state.set_linear_velocity(current_velocity)
