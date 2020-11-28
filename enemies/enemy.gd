extends Area2D
class_name Enemy


export(PackedScene) var bullet_scene

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
	# FIXME make different kind of enemies, each assigned a different color and shooting pattern
	# change colors
	$Sprite.set_frame(randi()%4)
	var sprite_rotation = BULLET_DIRECTIONS[group].angle()
	$sprite_rotate.set_rotation(sprite_rotation)

	$bullet_time.start(rand_range(2.0, 5.0))


func _on_bullet_time_timeout():
	# Spawn bullet.
	var bullet = bullet_scene.instance()
	bullet.direction = BULLET_DIRECTIONS[group]
	bullet.rotation_degrees = -bullet.direction.x * 90
	bullet.position = $sprite_rotate/exit.global_position
	bullet.speed = bullet_speed
	bullet.friendly = false
	get_parent().add_child(bullet)
	# Restart with bullet's cooldown time.
	$bullet_time.wait_time = bullet.get_cooldown()
