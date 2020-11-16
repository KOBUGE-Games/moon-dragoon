extends Area2D

export var speed = 300

export var direction = Vector2(0, 1)

export var cooldown_min = 2.5
export var cooldown_max = 6.0


func get_cooldown():
	return rand_range(cooldown_min, cooldown_max)


func _ready():
	# FIXME: This is only for the lulz until proper artwork.
	modulate = Color(randf(), randf(), randf()).lightened(0.5)
	scale = Vector2(rand_range(0.7, 2.0), rand_range(0.7, 2.0))


func _physics_process(delta):
	position += direction * speed * delta


func _on_bullet_body_entered(body):
	if body is Player:
		print("Player hit!")
