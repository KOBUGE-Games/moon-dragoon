extends Area2D
class_name Enemy


export(PackedScene) var bullet_scene

export var bullet_speed = 400

const BULLET_DIRECTIONS = {
	"enemies_top": Vector2(0, 1),
	"enemies_left": Vector2(1, 0),
	"enemies_right": Vector2(-1, 0),
}

var group
var slot


signal killed(slot)


func die():
	$AnimationPlayer.play("explosion")
	$bullet_time.stop() # dont shoot when dying
	# start to die
	$die_time.wait_time = $AnimationPlayer.get_current_animation_length()
	$die_time.start()
	# make enemy uncollidable with bullets, prevents a bug where enemy dies multiple times
	self.set_collision_layer_bit(0,false)
	self.set_collision_mask_bit(0,false)


func _ready():
	# FIXME make different kind of enemies, each assigned a different color and shooting pattern
	# change colors
	$Sprite.set_frame(randi()%4)
	# face enemy in shooting direction
	var sprite_rotation = BULLET_DIRECTIONS[group].angle()
	$sprite_rotate.set_rotation(sprite_rotation)
	# Fade in from invisible.
	modulate.a = 0
	$AnimationPlayer.play("fadein")
	yield($AnimationPlayer, "animation_finished")
	# Start moving animation.
	$AnimationPlayer.play("boost")

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


func _on_die_time_timeout():
	# die after explosion animation finished
	emit_signal("killed", slot)
	queue_free()
