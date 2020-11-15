extends Area2D
class_name Enemy


export var speed = 300

# Updated by parent group on callback.
export var direction = Vector2(1, 0)


func flip_direction():
	direction *= -1


func _ready():
	# FIXME: Temporary coloring to make programmer art less boring.
	$Polygon2D.modulate = Color(randf(), randf(), randf())
	# FIXME: Only added for debugging purpose (see input_event callback below).
	input_pickable = true


func _process(delta):
	position += direction * speed * delta


# FIXME: Only added for debugging purpose, click == kill.
func _on_enemy_input_event(_viewport, event, _shape_idx):
	print(event)
	if event is InputEventMouseButton:
		queue_free()
