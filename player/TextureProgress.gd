extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shield_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	shield_timer = get_node("../shield_timer")
	set_max(get_parent().SHIELD_MAX)
	$refill.set_max(shield_timer.get_wait_time()*100)
	pass # Replace with function body.

func _physics_process(delta):
	self.set_rotation_degrees(-get_parent().get_rotation_degrees())
	self._set_global_position(Vector2(get_parent().get_global_position().x-128,global.screen_size.y-96))
	if get_parent().shield >= 0: # prevent negative values to add +1 to the bar
		set_value(get_parent().shield )
	if get_parent().shield < 3:
		$refill.set_value((shield_timer.get_wait_time()-shield_timer.get_time_left())*100)
	else:
		$refill.set_value(0)
	
