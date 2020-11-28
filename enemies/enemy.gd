extends Area2D
class_name Enemy


export(PackedScene) var bullet_scene
export(NodePath) var bullets_container

export var bullet_speed = 300

const BULLET_DIRECTIONS = {
	"enemies_top": Vector2(0, 1),
	"enemies_left": Vector2(1, 0),
	"enemies_right": Vector2(-1, 0),
}

var group
var slot


signal killed(slot)


func die():
	emit_signal("killed", slot)
	queue_free()


func _ready():
	# FIXME: Temporary coloring to make programmer art less boring.
	$Polygon2D.modulate = Color(randf(), randf(), randf())

	$bullet_time.start(rand_range(2.0, 5.0))


func _on_bullet_time_timeout():
	# Spawn bullet.
	var bullet = bullet_scene.instance()
	bullet.direction = BULLET_DIRECTIONS[group]
	bullet.rotation_degrees = -bullet.direction.x * 90
	bullet.position = global_position
	bullet.speed = bullet_speed
	bullet.friendly = false
	get_node(bullets_container).add_child(bullet)
	# Restart with bullet's cooldown time.
	$bullet_time.wait_time = bullet.get_cooldown()
