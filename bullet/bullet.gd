extends Area2D

var speed : int = 300
export var friendly = false

export var direction = Vector2(0, 1)

# When bullets hit the ground we yield to play an animation before
# freeing, so make sure we're not freeing it from another function.
var can_free = true


func _ready():
	# Toplevel means that it evolves in global coordinates,
	# and ignores the coordinates offset from its parent.
	# So we don't need to put those bullets as children of the level
	# scene to move independently from player.
	set_as_toplevel(true)

	if friendly:
		$Sprite.set_frame(0)
		$shimmer.set_self_modulate(Color("ffcc00"))
	else:
		$Sprite.set_frame(1)
		$shimmer.set_self_modulate(Color("cd87de"))


func _physics_process(delta):
	position += direction * speed * delta

	if can_free and \
			(position.x < 0 or position.x > global.screen_size.x \
			or position.y < 0 or position.y > global.screen_size.y):
		queue_free()


func _on_bullet_body_entered(body):
	if friendly:
		return

	if body is Player:
		body.hit(direction)
		queue_free()
	elif body is Terrain:
		# Stop detecting.
		can_free = false
		collision_layer = 0
		collision_mask = 0
		# Random delay to go "in" the terrain.
		yield(get_tree().create_timer(rand_range(0, 0.15)), "timeout")
		$AnimationPlayer.play("splash")
		# Follow terrain while exploding.
		direction = Vector2(-1, 0)
		speed = body.speed
		yield($AnimationPlayer, "animation_finished")
		queue_free()


func _on_bullet_area_entered(area):
	if friendly and area is Enemy:
		area.die()
		queue_free()
