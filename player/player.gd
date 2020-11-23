extends RigidBody2D
class_name Player

var speed_y = -700
var speed_x = 500

# gravity scale of the rigid body
const GRAVITY_NORMAL = 10
const GRAVITY_FLY = 5
const MAX_ROTATION = PI/3

# states
var contact_count
var contact_count_old # if there wont be different animations for flying and driving, this can be deleted

onready var ground_detect = $ground_detect
onready var shoot_timer = $shoot_timer
onready var weapon = $weapon

var weapon_rotation: float

func _physics_process(_delta):
	# weapon rotation
	weapon_rotation = (get_global_mouse_position() - weapon.get_global_position()).angle()
	weapon.set_rotation(weapon_rotation)
	
	# weapon shoot
	if Input.is_action_pressed("mouse_left") and shoot_timer.is_stopped():
		shoot_timer.start() # start cool down
		weapon.shoot((get_global_mouse_position() - self.get_global_position()).normalized())

func _integrate_forces(state):
	# input events
	var button_jump = Input.is_action_pressed("ui_up")
	var button_left = Input.is_action_pressed("ui_left")
	var button_right = Input.is_action_pressed("ui_right")
	if ground_detect.is_colliding():
		contact_count = 1
	else:
		contact_count = 0
	
	var current_velocity = state.get_linear_velocity()
	
	# Horizontal movement always depends on input.
	current_velocity.x = 0
	if button_left:
		current_velocity.x -= speed_x
	if button_right:
		current_velocity.x += speed_x
		
	# rotate back to horizontal when flying
	if contact_count == 0:
		set_angular_velocity(-get_rotation())
	if abs(get_rotation()) > MAX_ROTATION:
		set_rotation(sign(get_rotation()) * MAX_ROTATION)
	
	
	if (contact_count == 1) and (contact_count_old == 0):
		# FIXME add animation switch if needed, from flying to driving
		pass
	
	if button_jump and (contact_count == 1): # jump
		current_velocity.y = speed_y
		set_angular_velocity(0)
	elif button_jump and (state.get_contact_count() == 0): # reduce gravity
		current_velocity.y = get_linear_velocity().y
		set_gravity_scale(GRAVITY_FLY)
	else: # no jump pressed, normal gravity
		current_velocity.y = get_linear_velocity().y
		set_gravity_scale(GRAVITY_NORMAL)
	
	# safe former states
	contact_count_old = contact_count
	
	# Restrict position within game screen by scaling down velocity.
	if position.x < 0 and current_velocity.x < 0:
		# Down to 0 at -100 px.
		current_velocity.x = lerp(current_velocity.x, 0, position.x / -100)
	elif position.x > global.screen_size.x and current_velocity.x > 0:
		# Down to 0 at screen width + 100 px.
		current_velocity.x = lerp(current_velocity.x, 0, (position.x - global.screen_size.x) / 100)

#	current_velocity.x = -get_global_position().x * 100
	state.set_linear_velocity(current_velocity)
