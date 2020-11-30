extends Area2D

export var speed = 300
export var friendly = false

export var direction = Vector2(0, 1)

export var cooldown_min = 2.5
export var cooldown_max = 6.0


func get_cooldown():
	return rand_range(cooldown_min, cooldown_max)


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

	if position.x < 0 or position.x > global.screen_size.x \
			or position.y < 0 or position.y > global.screen_size.y:
		queue_free()


func _on_bullet_body_entered(body):
	if not friendly and body is Player:
		body.hit(direction)
		queue_free()


func _on_bullet_area_entered(area):
	if friendly and area is Enemy:
		area.die()
		queue_free()
