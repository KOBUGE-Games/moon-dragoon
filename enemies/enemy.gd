extends Area2D
class_name Enemy


export var speed = 300

# Updated by parent group on callback.
export var direction = Vector2(1, 0)
var group

export(PackedScene) var bullet_scene
export(NodePath) var bullets_container

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

	$bullet_time.start(rand_range(2.0, 5.0))


func _physics_process(delta):
	position += direction * speed * delta


func _on_bullet_time_timeout():
	# Spawn bullet.
	var bullet = bullet_scene.instance()
	bullet.direction = BULLET_DIRECTIONS[group]
	bullet.rotation_degrees = -bullet.direction.x * 90
	bullet.position = global_position
	bullet.friendly = false
	get_node(bullets_container).add_child(bullet)
	# Restart with bullet's cooldown time.
	$bullet_time.wait_time = bullet.get_cooldown()
