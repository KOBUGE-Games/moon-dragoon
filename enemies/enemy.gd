extends Area2D
class_name Enemy


export var speed = 300

# Updated by parent group on callback.
export var direction = Vector2(1, 0)
var group

export(PackedScene) var bullet_scene

const BULLET_DIRECTIONS = {
	"enemies_top": Vector2(0, 1),
	"enemies_left": Vector2(1, 0),
	"enemies_right": Vector2(-1, 0),
}


func flip_direction():
	direction *= -1


func _ready():
	# FIXME: Temporary coloring to make programmer art less boring.
	$Polygon2D.modulate = Color(randf(), randf(), randf())
	# FIXME: Only added for debugging purpose (see input_event callback below).
	input_pickable = true

	$bullet_time.start(rand_range(2.0, 5.0))


func _physics_process(delta):
	position += direction * speed * delta


# FIXME: Only added for debugging purpose, click == kill.
func _on_enemy_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		queue_free()


func _on_bullet_time_timeout():
	# Spawn bullet.
	var bullet = bullet_scene.instance()
	bullet.direction = BULLET_DIRECTIONS[group]
	bullet.rotation_degrees = -bullet.direction.x * 90
	bullet.position = global_position
	# FIXME: Find a nicer way to access this.
	$"/root/level1".add_child(bullet)
	# Restart with bullet's cooldown time.
	$bullet_time.wait_time = bullet.get_cooldown()
