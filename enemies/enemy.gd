extends Area2D
class_name Enemy


export(PackedScene) var bullet_scene

export var base_score = 25
export var bullet_speed = 400
export var bullet_speed_endgame : int = 700

export(Vector2) var cooldown_earlygame = Vector2(2.5, 6.0)
export(Vector2) var cooldown_endgame = Vector2(1.0, 3.5)

const BULLET_DIRECTIONS = {
	"enemies_top": Vector2(0, 1),
	"enemies_left": Vector2(1, 0),
	"enemies_right": Vector2(-1, 0),
}

var group
var slot

# Used for a hacky, gameover animation.
var frenzy = false


signal killed(slot)


func die():
	$explode.play()
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

	# Fast shoot on spawn.
	$bullet_time.start(rand_range(0.5, 2.0))

	# Difficulty based on time.
	bullet_speed = lerp(bullet_speed, bullet_speed_endgame, global.get_difficulty_ratio())


func get_cooldown():
	# Rank up difficulty over time
	var cooldown = cooldown_earlygame.linear_interpolate(
				cooldown_endgame,
				global.get_difficulty_ratio())
	return rand_range(cooldown.x, cooldown.y)


func _on_bullet_time_timeout():
	# Spawn bullet.
	var bullet = bullet_scene.instance()
	bullet.position = $sprite_rotate/exit.global_position
	bullet.speed = bullet_speed
	if frenzy: # We go nuts for the end animation.
		bullet.direction = ($sprite_rotate/exit.global_position - global_position).normalized()
		bullet.rotation = bullet.direction.angle() - PI / 2
		# Friendly fire!
		bullet.friendly = true
		$bullet_time.wait_time = randf()
	else: # Normal behavior.
		bullet.direction = BULLET_DIRECTIONS[group]
		bullet.rotation_degrees = -bullet.direction.x * 90
		bullet.friendly = false
		$bullet_time.wait_time = get_cooldown()
	get_parent().add_child(bullet)


func _on_die_time_timeout():
	# Increase score count.
	global.increase_score(base_score)
	# Die after explosion animation finished
	emit_signal("killed", slot)
	queue_free()


# Called on gameover for a silly animation.
func go_nuts():
	# Make bullets rain
	frenzy = true
	bullet_speed = 800
	$bullet_time.start(randf())
	if randi() % 2:
		scale.x = -1
	$anim_nuts.playback_speed = rand_range(0.8, 1.2)
	$anim_nuts.play("dance")
